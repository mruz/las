<?php

namespace Las\Backend\Controllers;

use Las\Library\Las;
use Las\Models\Firewalls;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Firewall Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class FirewallsController extends IndexController
{

    /**
     * Index action - display all firewalls
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Firewalls'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['name', 'name DESC', 'status', 'status DESC']) ? $value : null;
        });

        // Get networks and prepare pagination
        $paginator = new Paginator([
            "data" => Firewalls::find(['order' => $this->request->getQuery('order', 'in_array', 'id', true)]),
            "limit" => $this->request->getQuery('limit', 'int', 20, true),
            "page" => $this->request->getQuery('page', 'int', 1, true)
        ]);

        $this->view->setVars([
            'pagination' => $paginator->getPaginate(),
        ]);
    }

    /**
     * Add action - add the new firewall
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("You can use the default firewalls") . ': ' . $this->tag->linkTo(['doc/examples/default', __('Examples'), 'target' => '_blank']));

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Firewalls') . ' / ' . __('Add'));
        $this->view->pick('firewalls/write');
        $this->view->setVars([
            'status' => Firewalls::status(true),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $firewall = new Firewalls();
            $valid = $firewall->write();

            // Check if data are valid
            if ($valid instanceof Firewalls) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        }
    }

    /**
     * Compile action - compile the firewall
     *
     * @package     las
     * @version     1.0
     */
    public function compileAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst(intval($params[0]) ? $params[0] : ['name=:name:', 'bind' => ['name' => $params[0]]])) {
            $this->tag->setTitle(__('Firewalls') . ' / ' . __('Compile'));
            $this->view->pick('msg');

            // Compile at real time or trigger compile
            if ($this->las['general']['realTime'] && $this->las['general']['rootPassword']) {
                try {
                    // Try to run command as root
                    $output = Las::cmd('php ' . ROOT_PATH . '/private/index.php firewall compile ' . $firewall->id, true);

                    // Update firewall's status
                    $firewall->status = Firewalls::COMPILED;
                    $firewall->update();

                    $this->tag->setTitle(__('Success'));
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The :name firewall was compiled.", [':name' => '<i>' . $firewall->name . '</i>']));
                    $this->view->setVar('title', __('Success'));

                    // Display debug if setting is enabled
                    if ($this->las['general']['debugCmd']) {
                        $this->view->setVars([
                            'redirect' => false,
                            'content' => $output
                        ]);
                    } else {
                        $this->view->setVars([
                            'redirect' => 'admin/firewalls/display/' . $firewall->id
                        ]);
                    }
                } catch (Exception $e) {
                    $errors = [
                        'error' => get_class($e) . '[' . $e->getCode() . ']: ' . $e->getMessage(),
                        'info' => $e->getFile() . '[' . $e->getLine() . ']',
                        'debug' => "Trace: \n" . $e->getTraceAsString() . "\n",
                    ];

                    // Display warning flash and log
                    $this->tag->setTitle(__('Warning'));
                    $this->view->setVars([
                        'title' => __('Warning'),
                        'content' => \Las\Bootstrap::log($errors)
                    ]);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
                }
            } else {
                // Trigger compile
                $this->tag->setTitle(__('Notice'));
                $this->view->setVars([
                    'title' => __('Notice'),
                    'redirect' => 'admin/firewalls'
                ]);
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("The :name firewall was scheduled to compile.", [':name' => '<i>' . $firewall->name . '</i>']));

                // Update firewall's status
                $firewall->status = Firewalls::COMPILE;
                $firewall->update();
            }
        }
    }

    /**
     * Delete action - delete the firewall
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($firewall->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/firewalls'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($firewall->getMessages()),
                    'redirect' => false
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display firewall's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst($params[0])) {
            $this->tag->setTitle(__('Firewalls') . ' / ' . __('Details'));
            $this->view->setVars([
                'firewall' => $firewall,
            ]);

            // Highlight <pre> tag
            $this->assets->addCss('css/highlightjs/arta.css');
            $this->assets->addJs('js/plugins/highlight.pack.js');
            $this->scripts = ['$(document).ready(function() { $("pre").each(function(i, e) {hljs.highlightBlock(e)}); });'];
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Display action - display compiled firewall
     *
     * @package     las
     * @version     1.0
     */
    public function displayAction()
    {
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst(intval($params[0]) ? $params[0] : ['name=:name:', 'bind' => ['name' => $params[0]]])) {
            $this->tag->setTitle(__('Firewalls') . ' / ' . __('Display'));
            $this->view->setVars([
                'firewall' => $firewall,
                'content' => Las::display($firewall->name)
            ]);

            // Highlight <pre> tag
            $this->assets->addCss('css/highlightjs/arta.css');
            $this->assets->addJs('js/plugins/highlight.pack.js');
            $this->scripts = ['$(document).ready(function() { $("pre").each(function(i, e) {hljs.highlightBlock(e)}); });'];
        }
    }

    /**
     * Edit action - edit the firewall
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst($params[0])) {
            // Set title, pick view and send variables
            $this->tag->setTitle(__('firewalls') . ' / ' . __('Edit'));
            $this->view->pick('firewalls/write');
            $this->view->setVars([
                'status' => Firewalls::status(true),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $valid = $firewall->write('update');

                // Check if data are valid
                if ($valid instanceof Firewalls) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                $diff = [
                    'status' => $firewall->status == Firewalls::COMPILED ? Firewalls::ACTIVE : $firewall->status
                ];
                // Values to fill out the form
                $this->tag->setDefaults(array_merge(get_object_vars($firewall), $diff));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Reload action - run the firewall
     *
     * @package     las
     * @version     1.0
     */
    public function reloadAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst(intval($params[0]) ? $params[0] : ['name=:name:', 'bind' => ['name' => $params[0]]])) {
            $this->tag->setTitle(__('Firewalls') . ' / ' . __('Run'));
            $this->view->pick('msg');

            // Reload at real time or trigger reload
            if ($this->las['general']['realTime'] && $this->las['general']['rootPassword']) {
                try {
                    // Try to run command as root
                    $output = Las::cmd('php ' . ROOT_PATH . '/private/index.php firewall display ' . $firewall->id . ' | sh', true);

                    $this->tag->setTitle(__('Success'));
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The :name firewall was reloaded.", [':name' => '<i>' . $firewall->name . '</i>']));
                    $this->view->setVar('title', __('Success'));

                    // Display debug if setting is enabled
                    if ($this->las['general']['debugCmd']) {
                        $this->view->setVars([
                            'content' => $output,
                            'redirect' => false
                        ]);
                    } else {
                        $this->view->setVars([
                            'redirect' => 'admin/firewalls/display/' . $firewall->id
                        ]);
                    }
                } catch (Exception $e) {
                    $errors = [
                        'error' => get_class($e) . '[' . $e->getCode() . ']: ' . $e->getMessage(),
                        'info' => $e->getFile() . '[' . $e->getLine() . ']',
                        'debug' => "Trace: \n" . $e->getTraceAsString() . "\n",
                    ];

                    // Display warning flash and log
                    $this->tag->setTitle(__('Warning'));
                    $this->view->setVars([
                        'title' => __('Warning'),
                        'content' => \Las\Bootstrap::log($errors)
                    ]);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
                }
            } else {
                // Trigger reload
                $this->tag->setTitle(__('Notice'));
                $this->view->setVars([
                    'title' => __('Notice'),
                    'redirect' => 'admin/firewalls'
                ]);
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("The :name firewall was scheduled to reload.", [':name' => '<i>' . $firewall->name . '</i>']));

                // Update firewall's status
                $firewall->status = Firewalls::RELOAD;
                $firewall->update();
            }
        }
    }

}
