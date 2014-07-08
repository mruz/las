<?php

namespace Las\Backend\Controllers;

use Las\Models\Networks;
use Las\Models\Settings;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Networks Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class NetworksController extends IndexController
{

    /**
     * Index action - display all networks
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Networks'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['interface', 'interface DESC', 'name', 'name DESC', 'subnetwork', 'subnetwork DESC', 'status', 'status DESC', 'type', 'type DESC']) ? $value : null;
        });

        // Get networks and prepare pagination
        $paginator = new Paginator([
            "data" => Networks::find(['order' => $this->request->getQuery('order', 'in_array', 'id', true)]),
            "limit" => $this->request->getQuery('limit', 'int', 20, true),
            "page" => $this->request->getQuery('page', 'int', 1, true)
        ]);

        $this->view->setVars([
            'pagination' => $paginator->getPaginate(),
            'bitRate' => Settings::options('bitRate', $this->las['general']['bitRate']),
        ]);
    }

    /**
     * Add action - add the new network
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        // Set title, pick view and send variables
        $this->tag->setTitle(__('Networks') . ' / ' . __('Add'));
        $this->view->pick('networks/write');
        $this->view->setVars([
            'type' => Networks::type(true),
            'status' => Networks::status(true),
            'bitRate' => Settings::options('bitRate', $this->las['general']['bitRate']),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $network = new Networks();
            $valid = $network->write();

            // Check if data are valid
            if ($valid instanceof Networks) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        } else {
            $this->tag->setDefaults([
                'mask' => '/24',
            ]);
        }
    }

    /**
     * Delete action - delete the network
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $network = Networks::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($network->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/networks'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($network->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display network's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $network = Networks::findFirst($params[0])) {
            $this->tag->setTitle(__('Networks') . ' / ' . __('Details'));
            $this->view->setVars([
                'network' => $network,
                'bitRate' => Settings::options('bitRate', $this->las['general']['bitRate']),
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the network
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $network = Networks::findFirst($params[0])) {
            // Set title, pick view and send variables
            $this->tag->setTitle(__('Networks') . ' / ' . __('Edit'));
            $this->view->pick('networks/write');
            $this->view->setVars([
                'type' => Networks::type(true),
                'status' => Networks::status(true),
                'bitRate' => Settings::options('bitRate', $this->las['general']['bitRate']),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $valid = $network->write('update');

                // Check if data are valid
                if ($valid instanceof Networks) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                $diff = [
                    'subnetwork' => long2ip($network->subnetwork),
                    'IP' => long2ip($network->IP),
                    'gateway' => long2ip($network->gateway),
                ];
                // Values to fill out the form
                $this->tag->setDefaults(array_merge(get_object_vars($network), $diff));
            }
        } else {
            parent::notFoundAction();
        }
    }

}
