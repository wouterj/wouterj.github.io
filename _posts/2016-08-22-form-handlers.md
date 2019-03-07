---
layout: post
title: Trimming your Controllers using Form Handlers
categories:
- article
tags:
- symfony
- bundles

---
"Your application should have thin controllers!" It's one of the most common
statements in framework-world. It's the basis of creating a decoupled
code-base. Yet, creating thin controller can be quite a challenge. Hostnet's
[FormHandlerBundle][bundle-github] can help you quite a bit. Let's have a
deeper look!

In this post, I'll be using the `BlogController#commentNewAction()` controller
of the [Symfony demo][sf-demo]:

```php
// src/AppBundle/Controller/BlogController.php

// ...
public function commentNewAction(Request $request, Post $post)
{
    $form = $this->createForm(CommentType::class);

    $form->handleRequest($request);

    if ($form->isSubmitted() && $form->isValid()) {
        /** @var Comment $comment */
        $comment = $form->getData();
        $comment->setAuthorEmail($this->getUser()->getEmail());
        $comment->setPost($post);

        $entityManager = $this->getDoctrine()->getManager();
        $entityManager->persist($comment);
        $entityManager->flush();

        return $this->redirectToRoute('blog_post', ['slug' => $post->getSlug()]);
    }

    return $this->render('blog/comment_form_error.html.twig', [
        'post' => $post,
        'form' => $form->createView(),
    ]);
}
```

While the controller doesn't do a lot of things, it's impossible to call it
thin. The main reason? It manages one big task: Handling form submission. Let's
move this to a service as well!

    [example]
    You can check out the final working version at
    <https://github.com/wouterj-nl/form-handler>

## Meet the HostnetFormHandlerBundle

The [HostnetFormHandlerBundle][bundle-github] introduces the concept of *form
handlers*. These handle form submissions through the request. Install the
bundle using Composer:

```shell
$ composer require hostnet/form-handler-bundle
```

...and enable it:

```php
// app/AppKernel.php

// ...
public function registerBundles()
{
    $bundles = [
        // ...
        new Hostnet\Bundle\FormHandlerBundle\FormHandlerBundle(),
    ];

    // ...
}
```

### Creating a Comment Form Handler

Now we can extract the form handling part from the controller. First things
first, the form has to be rendered:

```php
// src/AppBundle/Form/CommentFormHandler.php
namespace AppBundle\Form;

use Hostnet\Component\Form\AbstractFormHandler;

// Handlers must implement FormHandlerInterface, but extending the
// AbstractFormHandler makes things much easier.
class CommentFormHandler extends AbstractFormHandler
{
    public function getData()
    {
        // returns the initial form data (e.g. a new entity).
        // As the CommentType constructs the initial data itself using the
        // data_class option, we don't return anything here
        return null;
    }

    public function getType()
    {
        // the FQCN of the form type related to this handler
        return CommentType::class;
    }
}
```

This handler is now capable of creating the required `CommentType` form.

In a controller, pass this form handler to the `form_handler.provider.simple`
service to handle the form:

```php
use AppBundle\Form\CommentFormHandler;

// ...
public function commentNewAction(Request $request, Post $post)
{
    $handler = new CommentFormHandler();

    $this->get('form_handler.provider.simple')->handle($request, $handler);

    return $this->render('blog/comment_form_error.html.twig', [
        'post' => $post,
        'form' => $handler->getForm()->createView(),
    ]);
}
```

The form provider will now create the form based on `getType()` and handle it
using the passed request.

## Handle Successful Form Submissions

To actually handle the form, we have to implement `FormSuccesHandlerInterface`
and its `onSuccess()` method. This method is executed when the form is
submitted and valid.

```php
// ...
use Hostnet\Component\Form\FormSuccesHandlerInterface;
use Symfony\Component\Security\Core\Authentication\Token\Storage\TokenStorageInterface;
use Symfony\Component\HttpFoundation\Request;
use Doctrine\Common\Persistence\ObjectManager;
use AppBundle\Entity\Comment;

// ...
class CommentFormHandler extends AbstractFormHandler implements FormSuccesHandlerInterface
{
    /** @var ObjectManager **/
    private $entityManager;
    /** @var TokenStorageInterface **/
    private $tokenStorage;

    public function __construct(ObjectManager $manager, TokenStorageInterface $tokenStorage)
    {
        $this->entityManager = $manager;
        $this->tokenStorage  = $tokenStorage;
    }
    
    public function onSuccess(Request $request)
    {
        $currentUser = $this->tokenStorage->getToken()->getUser();
        $post = ...;

        // get the form data (Comment entity) after success
        /** @var Comment $comment */
        $comment = $this->getForm()->getData();
        $comment->setAuthorEmail($currentUser->getEmail());
        $comment->setPost($post);

        // persist the new Comment entity
        $this->entityManager->persist($comment);
        $this->entityManager->flush($comment);

        // this is passed to the controller
        return true;
    }

    // ...
}
```

As the handler now has some dependencies, create a service to manage it:

```yaml
# app/config/services.yml
services:
    app.comment_form_handler:
        class:    AppBundle\Form\CommentFormHandler
        shared:   false # form handlers are statefull, never share them.
        autowire: true  # we're lazy, let the container figure out all class dependencies
```

And slightly tweak the controller to use this service:

```php
// ...
public function commentNewAction(Request $request, Post $post)
{
    // get the handler service
    $handler = $this->get('app.comment_form_handler');

    $result = $this->get('form_handler.provider.simple')->handle($request, $handler);
    if ($result) {
        // the form handler returns true, which means the form is handled
        // successfully
        return $this->redirectToRoute('blog_post', ['slug' => $post->getSlug()]);
    }

    // the form is not submitted or not valid, render the page again
    return $this->render('blog/comment_form_error.html.twig', [
        'post' => $post,
        'form' => $handler->getForm()->createView(),
    ]);
}
```

## Getting the current Post in the Handler

There is one missing bit in the form handler: It has to be aware of the post
we're commenting on. To fix this, add a new `$post` property and setter in the
handler. Form handlers are already statefull. This means adding another
statefull property wouldn't harm anyone.

```php
use AppBundle\Entity\Post;
// ...

class CommentFormHandler extends AbstractFormHandler implements FormSuccesHandlerInterface
{
    /** @var Post **/
    private $post;

    // ...   
    public function setPost(Post $post)
    {
        $this->post = $post;
    }

    public function onSuccess(Request $request)
    {
        $post = $this->post;
        // ...
    }
}
```

Now, from inside the controller, pass the current post to the handler:

```php
// ...
public function commentNewAction(Request $request, Post $post)
{
    $handler = $this->get('app.comment_form_handler');
    $handler->setPost($post);

    // ...
}
```

Cool, that's it! All form handling stuff is now managed in a form handler. This
makes it easy to reuse. The final controller contains 15 lines (compared to the
original 23 lines). More importantly, the form handling logic is now delegated
to a reusable service.

## Take Home's

 * Controllers shouldn't contain much logic
 * Hostnet's FormHandlerBundle helps you extract form handling logic

On top of these features, the bundle provides a param converter to pass form
handlers as controller arguments. If you find this usefull, checkout the
[docs][bundle-docs].

 [bundle-github]: https://github.com/hostnet/form-handler-bundle
 [sf-demo]: https://github.com/symfony/symfony-demo#installation
 [bundle-docs]: https://github.com/hostnet/form-handler-bundle#usage
