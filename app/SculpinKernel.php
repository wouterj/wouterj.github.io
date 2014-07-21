<?php

error_reporting(E_ALL ^ E_WARNING);

use Sculpin\Bundle\SculpinBundle\HttpKernel\AbstractKernel;

class SculpinKernel extends AbstractKernel
{
    public function getAdditionalSculpinBundles()
    {
        return array();
    }
}
