<?php

namespace Las\Backend\Controllers;

use Las\Library\Arr;
use Las\Models\Clients;
use Las\Models\Devices;
use Las\Models\Payments;
use Las\Models\Roles;
use Las\Models\RolesUsers;
use Las\Models\Settings;

/**
 * Backend Index Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class IndexController extends \Phalcon\Mvc\Controller
{

    public $las = [];
    public $scripts = [];

    /**
     * Before Action
     *
     * @package     las
     * @version     1.0
     */
    public function beforeExecuteRoute($dispatcher)
    {
        // Set default title
        $this->tag->setTitle('Index');

        // Add css and js to assets collection
        $this->assets->addCss('css/fonts.css');
        $this->assets->addCss('css/app.css');
        $this->assets->addJs('js/plugins.js');
    }

    /**
     * Initialize
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        // Redirect to home page if user is not admin
        if (!$this->auth->logged_in('admin')) {
            $adminRole = Roles::findFirst('name="admin"');
            if (!RolesUsers::count('role_id=' . $adminRole->id)) {
                $this->response->redirect('install');
            } else {
                $this->response->redirect('');
            }
        }

        // Check the session lifetime
        if ($this->session->has('last_active') && time() - $this->session->get('last_active') > $this->config->session->options->lifetime) {
            $this->session->destroy();
        }

        $this->session->set('last_active', time());

        // Set the language from session
        if ($this->session->has('lang')) {
            $this->i18n->lang($this->session->get('lang'));
            // Set the language from cookie
        } elseif ($this->cookies->has('lang')) {
            $this->i18n->lang($this->cookies->get('lang')->getValue());
        }

        // Get the settings
        $this->las = Arr::from_model(Settings::find(['status = ' . Settings::ACTIVE]), 'category', ['name' => 'value']);

        // Send langs to the view
        $this->view->setVars([
            // Translate langs before
            'siteLangs' => array_map('__', $this->config->i18n->langs->toArray()),
            'las' => $this->las
        ]);
    }

    /**
     * Index Action - admin panel home page
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Admin panel'));
        $this->assets->addJs('js/plugins/refresh.js');
        $this->scripts = [
            "$('.refresh').refresh(" . ($this->url->getBaseUri() != '/' ? "{ base_uri: '" . $this->url->getBaseUri() . "'}" : '') . ");",
        ];
        $this->view->setVars([
            'clients' => Clients::find(),
            'devices' => Devices::find(),
            'balances' => Payments::sum([
                'conditions' => 'status=' . Payments::SUCCESS,
                'column' => 'amount',
            ]),
        ]);
    }

    /**
     * After Action
     *
     * @package     las
     * @version     1.0
     */
    public function afterExecuteRoute($dispatcher)
    {
        // Set final title
        $this->tag->setTitleSeparator(' | ');
        $this->tag->appendTitle($this->config->app->name);

        // Set scripts
        $this->scripts [] = '$("#nav-' . $this->dispatcher->getControllerName() . '").collapse()';
        $this->view->setVar('scripts', $this->scripts);

        // Minify css and js collection
        \Las\Library\Tool::assetsMinification();

        $this->view->setVars([
            'action' => $this->dispatcher->getActionName(),
            'controller' => $this->dispatcher->getControllerName()
        ]);
    }

    /**
     * Not found Action
     *
     * @package     las
     * @version     1.0
     */
    public function notfoundAction()
    {
        // Send a HTTP 404 response header
        $this->response->setStatusCode(404, "Not Found");
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_ACTION_VIEW);
        $this->view->setMainView('404');
        $this->assets->addCss('css/fonts.css');
    }

}
