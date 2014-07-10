<?php

namespace Las\Doc\Controllers;

class ExamplesController extends IndexController
{

    public function indexAction()
    {

    }

    public function defaultAction()
    {
        $markdown = new \Las\Library\Parsedown\ParsedownExtra();

        foreach (new \RecursiveDirectoryIterator(ROOT_PATH . '/app/cli/views', \RecursiveDirectoryIterator::SKIP_DOTS) as $file) {
            echo '<h3 id="' . $file->getBasename('.volt') . '">' . $file->getBasename('.volt') . '</h3>';
            echo $markdown->text('<pre class="django" style="font-size: 11px;"><code style="word-wrap: normal; white-space: pre; overflow: auto;">' . file_get_contents($file->getRealPath()) . '</code></pre>');
            echo '<hr />';
        }
    }

}
