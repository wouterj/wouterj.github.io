<?php

namespace WouterJ\Twig;

class Site extends \Twig_Extension
{
    public function getFilters()
    {
        return array(
            new \Twig_SimpleFilter('excerpt', array($this, 'excerpt')),
        );
    }

    public function excerpt($post)
    {
        if (!array_key_exists('content', $post['blocks'])) {
            return '';
        }

        $dom = new \DOMDocument();
        $dom->loadHTML($post['blocks']['content']);

        $paragraphs = $dom->getElementsByTagName('p');
        if ($paragraphs->length) {
            return $paragraphs->item(0)->nodeValue;
        }
    }

    public function getName()
    {
        return 'site';
    }
}
