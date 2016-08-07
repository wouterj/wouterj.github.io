<?php

namespace WouterJ\Formatter;

use Sculpin\Core\Sculpin;
use Sculpin\Core\Event\ConvertEvent;
use Sculpin\Bundle\TwigBundle\SculpinTwigBundle;
use Sculpin\Bundle\MarkdownBundle\SculpinMarkdownBundle;
use Symfony\Component\Process\ProcessBuilder;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class Site implements EventSubscriberInterface
{
    public function compileBlocks(ConvertEvent $event)
    {
        if (!$event->isHandledBy(SculpinMarkdownBundle::CONVERTER_NAME, SculpinTwigBundle::FORMATTER_NAME)) {
            return;
        }

        $event->source()->setContent(preg_replace_callback(
            '/^    \[(note|caution|tip|sidebar)(?: "(.*?)")?\]((?:\s{5}.+$)+)/m',
            function ($m) {
                return '<span data-wj-block="'.$m[1].'"'.($m[2] ? ' data-wj-block-title="'.trim($m[2]).'"' : '').'>'.
                           trim(preg_replace('/^\s{4}/m', '', $m[3])).
                       '</span>';
            },
            $event->source()->content()
        ));
    }

    public function parseBlocks(ConvertEvent $event)
    {
        if (!$event->isHandledBy(SculpinMarkdownBundle::CONVERTER_NAME, SculpinTwigBundle::FORMATTER_NAME)) {
            return;
        }

        $event->source()->setContent(preg_replace_callback(
            '/<span data-wj-block="(\w+)"(?: data-wj-block-title="(.+?)")?>(.+?)<\/span>/s',
            function ($m) {
                $html = '<aside class="side  side--'.$m[1].'" data-type="'.$m[1].'">';
                if ($m[2]) {
                    $html .= '<h1>'.$m[2].'</h1>';
                }
                $html .= $m[3];
                $html .= '</aside>';

                return $html;
            },
            $event->source()->content()
        ));
    }

    public function parseCode(ConvertEvent $event)
    {
        if (!$event->isHandledBy(SculpinMarkdownBundle::CONVERTER_NAME, SculpinTwigBundle::FORMATTER_NAME)) {
            return;
        }

        # transforms blockquotes to code blocks
        $content = preg_replace_callback(
            '/^    \[([\w,]+)\]((?:\s{5}.+$)+)/m',
            function ($m) {
                return '~~~'.$m[1].PHP_EOL.trim(preg_replace('/^ {4}/m', '', $m[2])).PHP_EOL.'~~~';
            },
            $event->source()->content()
        );

        $event->source()->setContent($content);
    }

    public function highlightCodeBlocks(ConvertEvent $event)
    {
        if (!$event->isHandledBy(SculpinMarkdownBundle::CONVERTER_NAME, SculpinTwigBundle::FORMATTER_NAME)) {
            return;
        }

        $content = $event->source()->content();

        $dom = new \DOMDocument();
        $dom->loadHTML($content, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        $processBuilder = ProcessBuilder::create()->setPrefix(['pygmentize', '-Pstyle=wouterj']);

        foreach ($dom->getElementsByTagName('pre') as $pre) {
            $code = $pre->getElementsByTagName('code');

            if ($code->length) {
                $processBuilder->setArguments(['-fhtml']);
                $code = $code->item(0);

                if ($code->hasAttribute('class')) {
                    $language = $code->getAttribute('class');

                    switch ($language) {
                        case 'none':
                            continue 2;

                        case 'bash':
                            break;

                        case 'php':
                            $language = 'inline-php';
                            // no break is intended, PHP blocks need linenumbers

                        default:
                            $processBuilder->add('-Plinenos=1');
                    }

                    $processBuilder->add('-l'.$language);
                } else {
                    // guess the lexer
                    $processBuilder->add('-g');
                    $processBuilder->add('-Plinenos=1');
                }

                $process = $processBuilder->setInput(trim($code->nodeValue))->getProcess();
                $highlightedCode = $process->mustRun()->getOutput();
                $fragment = $dom->createDocumentFragment();
                $fragment->appendXML($highlightedCode);

                $pre->parentNode->replaceChild($fragment, $pre);
            }
        }

        $event->source()->setContent($dom->saveHTML());
    }

    public function addHeadlineIds(ConvertEvent $event)
    {
        if (!$event->isHandledBy(SculpinMarkdownBundle::CONVERTER_NAME, SculpinTwigBundle::FORMATTER_NAME)) {
            return;
        }

        $content = $event->source()->content();

        $dom = new \DOMDocument();
        $dom->loadHTML($content, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        
        foreach (array('h1', 'h2', 'h3', 'h4', 'h5', 'h6') as $level) {
            foreach ($dom->getElementsByTagName($level) as $headline) {
                $id = strtolower(trim(preg_replace('/\W+/', '-', $headline->nodeValue), '-'));
                $headline->setAttribute('id', $id);

                $a = $dom->createElement('a', '&#xf068;');
                $a->setAttribute('href', '#'.$id);
                $a->setAttribute('class', 'section-link');

                $headline->insertBefore($a, $headline->firstChild);
            }
        }

        $event->source()->setContent($dom->saveHTML());
    }

    public function fixImages(ConvertEvent $event)
    {
        if (!$event->isHandledBy(SculpinMarkdownBundle::CONVERTER_NAME, SculpinTwigBundle::FORMATTER_NAME)) {
            return;
        }

        $content = $event->source()->content();

        $dom = new \DOMDocument();
        $dom->loadHTML($content, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);

        foreach ($dom->getElementsByTagName('img') as $img) {
            $img->setAttribute('class', 'img--stripe');
        }

        $event->source()->setContent($dom->saveHTML());
    }

    public function styleIntro(ConvertEvent $event)
    {
        if (!$event->isHandledBy(SculpinMarkdownBundle::CONVERTER_NAME, SculpinTwigBundle::FORMATTER_NAME)) {
            return;
        }

        $content = $event->source()->content();

        $dom = new \DOMDocument();
        $dom->loadHTML($content, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);

        $intro = $dom->getElementsByTagName('p')->item(0);
        if ($intro) {
            $intro->setAttribute('class', 'post__intro');

            $cf = $dom->createElement('div');
            $cf->setAttribute('class', 'cf');
            $intro->parentNode->insertBefore($cf, $intro->nextSibling);
        }

        $event->source()->setContent($dom->saveHTML());
    }

    public static function getSubscribedEvents()
    {
        return array(
            Sculpin::EVENT_BEFORE_CONVERT => array(
                array('compileBlocks', 10),
                array('parseCode', 0)
            ),
            Sculpin::EVENT_AFTER_CONVERT => array(
                array('parseBlocks', 0),
                array('highlightCodeBlocks', -99),
                array('addHeadlineIds', 0),
                array('fixImages', 0),
                array('styleIntro', 0)
            ),
        );
    }
}
