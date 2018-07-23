<?php

namespace Las\Backend\Controllers;

use Las\Models\Clients;
use Las\Models\Devices;
use Las\Models\Services;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Services Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class ServicesController extends IndexController
{

    /**
     * Index action - display all services
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Services'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['client_id', 'client_id DESC', 'endingPort', 'endingPort DESC', 'name', 'name DESC', 'priority', 'priority DESC', 'status', 'status DESC', 'startingPort', 'startingPort DESC']) ? $value : null;
        });

        // Check if limit to client's services
        if ($client = $this->request->getQuery('client', 'int', null, true)) {
            $data = Services::find(['client_id = :client:', 'order' => $this->request->getQuery('order', 'in_array', 'id', true), 'bind' => ['client' => $client]]);
        } else {
            $data = Services::find(['order' => $this->request->getQuery('order', 'in_array', 'sorting DESC', true)]);
        }

        // Get services and prepare pagination
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
     * Add action - add the new service
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $clients = Clients::find(['status=:status:', 'bind' => ['status' => Clients::ACTIVE]]);
        $devices = Devices::find(['status=:status:', 'bind' => ['status' => Devices::ACTIVE]]);

        if (!count($clients)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the client first") . ': ' . $this->tag->linkTo('admin/clients/add', __('Add')));
        }
        if (!count($devices)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the device first") . ': ' . $this->tag->linkTo('admin/devices/add', __('Add')));
        }

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Services') . ' / ' . __('Add'));
        $this->view->pick('services/write');
        $this->view->setVars([
            'clients' => $clients,
            'devices' => $devices,
            'chain' => Services::chain(true),
            'direction' => Services::direction(true),
            'status' => Services::status(true),
            'priority' => Services::priority(true),
            'protocol' => Services::protocol(true),
            'portDirection' => Services::portDirection(true),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $service = new Services();
            $service->setClients($clients);
            $service->setDevices($devices);
            $valid = $service->write();

            // Check if data are valid
            if ($valid instanceof Services) {
                $_POST = [];
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        } else {
            $this->tag->setDefaults([
                'priority' => $this->las['qos']['defaultClass'],
                'sorting' => 100,
            ]);
        }
    }

    /**
     * Delete action - delete the service
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $service = Services::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($service->delete() == true) {
                // Display success flash and service
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'service' => 'admin/services'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($service->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display service's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $service = Services::findFirst($params[0])) {
            $this->tag->setTitle(__('Services') . ' / ' . __('Details'));
            $this->view->setVars([
                'service' => $service,
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the service
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $service = Services::findFirst($params[0])) {
            $clients = Clients::find(['status=:status:', 'bind' => ['status' => Clients::ACTIVE]]);
            $devices = Devices::find(['status=:status:', 'bind' => ['status' => Devices::ACTIVE]]);

            if (!count($clients)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the client first") . ': ' . $this->tag->linkTo('admin/clients/add', __('Add')));
            }
            if (!count($devices)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the device first") . ': ' . $this->tag->linkTo('admin/devices/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Services') . ' / ' . __('Add'));
            $this->view->pick('services/write');
            $this->view->setVars([
                'clients' => $clients,
                'devices' => $devices,
                'chain' => Services::chain(true),
                'direction' => Services::direction(true),
                'status' => Services::status(true),
                'priority' => Services::priority(true),
                'protocol' => Services::protocol(true),
                'portDirection' => Services::portDirection(true),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $service->setClients($clients);
                $service->setDevices($devices);
                $valid = $service->write('update');

                // Check if data are valid
                if ($valid instanceof Services) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                $diff = [
                    'client' => $service->client_id,
                    'device' => $service->device_id,
                    'IP' => $service->IP ? long2ip($service->IP) : null,
                ];
                // Values to fill out the form
                $this->tag->setDefaults(array_merge(get_object_vars($service), $diff));
            }
        } else {
            parent::notFoundAction();
        }
    }

}
