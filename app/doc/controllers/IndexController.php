<?php

namespace Las\Doc\Controllers;

use Las\Library\I18n;
use Las\Library\Auth;

/**
 * Doc Index Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class IndexController extends \Phalcon\Mvc\Controller
{

    public $site_desc;
    public $scripts = array();

    /**
     * Before Action
     *
     * @package     las
     * @version     1.0
     */
    public function beforeExecuteRoute($dispatcher)
    {
        // Set default title and description
        $this->tag->setTitle('Default');
        $this->site_desc = 'Default';
        
        $controller = $this->dispatcher->getControllerName();
        $action = $this->dispatcher->getActionName();
        if ($controller != 'index') {
            if ($action == 'index') {
                $this->tag->setTitle(__(ucfirst($controller)));
            } else {
                $this->tag->setTitle(__(ucfirst($controller)) . ' / ' . __(ucfirst($action)));
            }
        }

        // Add css and js to assets collection
        $this->assets->addCss('css/fonts.css');
        $this->assets->addCss('css/app.css');
        $this->assets->addCss('css/highlightjs/arta.css');
        $this->assets->addJs('js/plugins.js');
        $this->assets->addJs('js/plugins/highlight.pack.js');
    }

    /**
     * Initialize
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        // Check the session lifetime
        if ($this->session->has('last_active') && time() - $this->session->get('last_active') > $this->config->session->options->lifetime) {
            $this->session->destroy();
        }

        $this->session->set('last_active', time());

        // Set the language from session
        if ($this->session->has('lang')) {
            I18n::instance()->lang($this->session->get('lang'));
            // Set the language from cookie
        } elseif ($this->cookies->has('lang')) {
            I18n::instance()->lang($this->cookies->get('lang')->getValue());
        }

        // Send i18n, auth and langs to the view
        $this->view->setVars(array(
            'auth' => Auth::instance(),
            'i18n' => I18n::instance(),
            // Translate langs before
            'siteLangs' => array_map('__', $this->config->i18n->langs->toArray())
        ));
    }

    /**
     * Index Action
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Documentation'));
    }

    /**
     * After Action
     *
     * @package     las
     * @version     1.0
     */
    public function afterExecuteRoute($dispatcher)
    {
        // Set final title and description
        $this->tag->setTitleSeparator(' | ');
        $this->tag->appendTitle($this->config->app->name);
        $this->view->setVar('site_desc', mb_substr($this->filter->sanitize($this->site_desc, 'string'), 0, 200, 'utf-8'));

        // Set scripts
        $this->scripts = ['$(document).ready(function() { $("pre code").each(function(i, e) {hljs.highlightBlock(e)}); });'];
        $this->view->setVar('scripts', $this->scripts);

        // Minify css and js collection
        \Las\Library\Tool::assetsMinification();
    }

    /**
     * Not found Action
     *
     * @package     las
     * @version     1.0
     */
    public function notFoundAction()
    {
        // Send a HTTP 404 response header
        $this->response->setStatusCode(404, "Not Found");
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
        $this->view->setMainView('404');
        $this->assets->addCss('css/fonts.css');
    }

}
