<?php

error_reporting(E_ALL ^ E_WARNING);

require_once dirname(__DIR__).'/vendor/autoload.php';

use Sculpin\Bundle\SculpinBundle\HttpKernel\AbstractKernel;

class SculpinKernel extends AbstractKernel
{
    public function getAdditionalSculpinBundles()
    {
        return array();
    }
}
