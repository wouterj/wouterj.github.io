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
        if (!isset($post['blocks']['content'])) {
            return '';
        }

        $dom = new \DOMDocument();
        var_dump($post['blocks']['content']);
        $dom->loadHTML($post['blocks']['content']);

        if ($elem = $dom->getElementsByTagName('p')->item(0)) {
            return $elem->nodeValue;
        }
    }

    public function getName()
    {
        return 'site';
    }
}
