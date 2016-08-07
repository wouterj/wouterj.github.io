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
        $dom->loadHTML($post['blocks']['content'], LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);

        var_dump(htmlspecialchars($post['blocks']['content']));
        $paragraphs = $dom->getElementsByTagName('p');
        var_dump($paragraphs);
        if ($paragraphs->length) {
            return $paragraphs->item(0)->nodeValue;
        }
    }

    public function getName()
    {
        return 'site';
    }
}
