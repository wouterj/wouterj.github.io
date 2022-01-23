---
layout: post
title: Repositories are just Collections
categories:
- article
tags:
- symfony
- doctrine
- oop
star: true

---
Repositories are just collections of things. A post repository is a collection
of posts, a user repository a collection of users. They allow to abstract away
all the persistence details. Yet, many people think of Doctrine repositories as
purely related to Doctrine, leading to strange abstractions. Let's create a
normal collection with Symfony and Doctrine today!

## It all starts with the Interface

When designing your application, start with designing your interfaces. If you
like your interfaces, the implementation will probably be nice as well. In this
post, we're going to design a collection of products. The interface first
contains some basic collection methods:

```php
// src/AppBundle/Product/ProductRepository.php
namespace AppBundle\Product;

interface ProductRepository extends \Countable
{
    /** @return Product[] */
    public function all();

    /** @return bool */
    public function includes(Product $product);

    /** @return int */
    public function count();
}
```

We can now count the number of products in the collection, get all products in
the collection and check if a product is included in the collection. Now, let's
add two simple methods for more specific operations on this collection:

```php
// src/AppBundle/Product/ProductRepository.php

// ...
interface ProductRepository extends \Countable
{
    // ...
    public function add(Product $product);

    /** @return null|Product */
    public function byId($id);
}
```

## A Basic Implementation

The most straight-forward way to implement collections in PHP is by using
arrays. Let's create an array based product collection:

```php
// src/AppBundle/Product/ArrayBasedProductRepository.php
namespace AppBundle\Product;

class ArrayBasedProductRepository implements ProductRepository
{
    private $products = [];

    public function all()
    {
        return $this->products;
    }

    public function includes(Product $product)
    {
        return in_array($product, $this->products);
    }

    public function count()
    {
        return count($this->products);
    }

    public function add(Product $product)
    {
        $this->products[$product->getId()] = $product;
    }

    public function byId($id)
    {
        if (!isset($this->products[$id])) {
            return null;
        }

        return $this->products[$id];
    }
}
```

Most of the methods in the interface can be mapped to simple PHP array
methods. This repository can be defined as a service:

```yaml
# app/config/services.yml
services:
    app.product_repository:
        class: AppBundle\Product\ArrayBasedProductRepository
```

Then you can probably imagine how we would use this product collection in a
controller:

```php
// src/AppBundle/Controller/ShopController.php
namespace AppBundle\Controller;

// ...
class ShopController extends Controller
{
    public function listAction()
    {
        $products = $this->get('app.product_repository')->all();

        return $this->render('shop/products.twig', [
            'products' => $products,
        ]);
    }

    public function productInfoAction($productId)
    {
        $product = $this->get('app.product_repository')->byId($productId);

        return $this->render('shop/product_info.twig', [
            'product' => $product,
        ]);
    }
}
```

## Using Doctrine

So far, we've only looked at normal repositories. I hope this brought the point
across that repositories are just collections. The nice thing about
repositories is that we can implement all sort of different backends for our
collections. As this post is also about Doctrine, let's create a product
collection based on Doctrine.

The `EntityRepository` shipped with the Doctrine ORM is a simple wrapper class
around the entity manager and the unit of work. The class isn't used in
Doctrine itself, it's purely an easy starting point for the users. This means
we can completely drop it and base our doctrine collection on top of the entity
manager:

```php
// src/AppBundle/Product/DoctrineBasedProductRepository.php
namespace AppBundle\Product;

use Doctrine\ORM\EntityManager;

class DoctrineBasedProductRepository implements ProductRepository
{
    private $entityManager;

    public function __construct(EntityManager $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function all()
    {
        // Create a basic DQL query to fetch all entities
        return $this->entityManager->createQuery('SELECT p FROM '.Product::class.' p')
            ->getResult();
    }

    public function includes(Product $product)
    {
        // Check if the entity is managed by the entity manager
        return $this->entityManager->contains($product);
    }

    public function count()
    {
        // Create a basic count DQL query
        return $this->entityManager->createQuery('SELECT count(p) FROM '.Product::class.' p')
            ->getSingleScalarResult();
    }

    public function add(Product $product)
    {
        $this->entityManager->persist($product);
    }

    public function byId($id)
    {
        // Fetch a product by id (note: No need to use DQL or the EntityRepository here either!)
        return $this->entityManager->find(Product::class, $id);
    }
}
```

As you can see, the code in here is just a bit more complex than using the
array repository. Even better, the usage of this repository has not changed a
single bit when comparing it with the `ArrayBasedProductRepository`. So we only
have to update the service definitions to use doctrine:

```yaml
# app/config/services.yml
services:
    app.product_repository:
        class: AppBundle\Product\DoctrineBasedProductRepository
        arguments: ['@doctrine.orm.entity_manager']
```

## Treat Repositories as Collections

As I tried to show in this post, treating repositories as collections has some
significant advantages:

 * The collection implementation is abstracted away, not much hassle with
   Doctrine anymore
 * All collection methods are located in one class/service. This means you
   never has to rely on both the entity repository and manager (in order to
   fetch and persist) anymore
 * Working with Doctrine as if it's a collection makes programming easier to
   follow

My last warning of this post is to not add non-collection related methods in
the repository. I sometimes see people adding `getXxxQuery()` methods in the
repository, as e.g. the form type requires you to set a query. These methods
tell something about the implementation. They are no longer related to
collections (try to think what this method should return in the
`ArrayBasedProductRepository`).

## Take Home's

 * The `EntityRepository` class shipped by Doctrine is purely to ease usage,
   it's not mandatory at all
 * Writing your own repositories allow you to abstract away Doctrine almost
   completely from your services and controllers
 * Repositories are just collections, please treat them as such
