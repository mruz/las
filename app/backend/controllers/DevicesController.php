<?php

namespace Las\Backend\Controllers;

use Las\Models\Clients;
use Las\Models\Devices;
use Las\Models\Networks;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Devices Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class DevicesController extends IndexController
{

    /**
     * Index action - display all devices
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Devices'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['client_id', 'client_id DESC', 'IP', 'IP DESC', 'lastActive', 'lastActive DESC', 'name', 'name DESC', 'status', 'status DESC', 'type', 'type DESC']) ? $value : null;
        });

        // Check if limit to client's devices
        if ($client = $this->request->getQuery('client', 'int', null, true)) {
            $data = Devices::find(['client_id = :client:', 'order' => $this->request->getQuery('order', 'in_array', 'id', true), 'bind' => ['client' => $client]]);
        } else {
            $data = Devices::find(['order' => $this->request->getQuery('order', 'in_array', 'id', true)]);
        }

        // Get devices and prepare pagination
        $paginator = new Paginator([
            "data" => $data,
            "limit" => $this->request->getQuery('limit', 'int', 20, true),
            "page" => $this->request->getQuery('page', 'int', 1, true)
        ]);

        $this->view->setVars([
            'pagination' => $paginator->getPaginate(),
        ]);
    }

    /**
     * Add action - add the new device
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $clients = Clients::find(['status!=:status:', 'bind' => ['status' => Clients::UNACTIVE]]);
        $networks = Networks::find(['status=:status:', 'bind' => ['status' => Networks::ACTIVE]]);

        if (!count($clients)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the client first") . ': ' . $this->tag->linkTo('admin/clients/add', __('Add')));
        }
        if (!count($networks)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the network first") . ': ' . $this->tag->linkTo('admin/networks/add', __('Add')));
        }

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Devices') . ' / ' . __('Add'));
        $this->view->pick('devices/write');
        $this->view->setVars([
            'clients' => $clients,
            'networks' => $networks,
            'type' => Devices::type(true),
            'status' => Devices::status(true),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $device = new Devices();
            $device->__set('clients', $clients);
            $device->__set('networks', $networks);
            $valid = $device->write();

            // Check if data are valid
            if ($valid instanceof Devices) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        }
    }

    /**
     * Delete action - delete the device
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $device = Devices::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($device->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/devices'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($device->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display device's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $device = Devices::findFirst($params[0])) {
            $this->tag->setTitle(__('Devices') . ' / ' . __('Details'));
            $this->view->setVars([
                'device' => $device,
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the device
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $device = Devices::findFirst($params[0])) {
            $clients = Clients::find(['status!=:status:', 'bind' => ['status' => Clients::UNACTIVE]]);
            $networks = Networks::find(['status=:status:', 'bind' => ['status' => Networks::ACTIVE]]);

            if (!count($clients)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the client first") . ': ' . $this->tag->linkTo('admin/clients/add', __('Add')));
            }
            if (!count($networks)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the network first") . ': ' . $this->tag->linkTo('admin/networks/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Devices') . ' / ' . __('Edit'));
            $this->view->pick('devices/write');
            $this->view->setVars([
                'clients' => $clients,
                'networks' => $networks,
                'type' => Devices::type(true),
                'status' => Devices::status(true),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $device->__set('clients', $clients);
                $device->__set('networks', $networks);
                $valid = $device->write('update');

                // Check if data are valid
                if ($valid instanceof Devices) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                // Values to fill out the form
                $this->tag->setDefaults([
                    'name' => $device->name,
                    'network' => $device->network_id,
                    'client' => $device->client_id,
                    'type' => $device->type,
                    'IP' => long2ip($device->IP),
                    'MAC' => $device->MAC,
                    'description' => $device->description,
                    'status' => $device->status,
                ]);
            }
        } else {
            parent::notFoundAction();
        }
    }

}
