<?php

namespace Las\Backend\Controllers;

use Las\Models\Devices;
use Las\Models\Redirects;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Redirects Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class RedirectsController extends IndexController
{

    /**
     * Index action - display all redirects
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Redirects'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['device_id', 'device_id DESC', 'name', 'name DESC', 'status', 'status DESC', 'type', 'type DESC']) ? $value : null;
        });

        // Check if limit to client's redirects
        if ($client = $this->request->getQuery('client', 'int', null, true)) {
            $data = Redirects::find(['client_id = :client:', 'order' => $this->request->getQuery('order', 'in_array', 'id', true), 'bind' => ['client' => $client]]);
        } else {
            $data = Redirects::find(['order' => $this->request->getQuery('order', 'in_array', 'id', true)]);
        }

        // Get redirects and prepare pagination
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
     * Add action - add the new redirect
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $devices = Devices::find(['status=:status:', 'bind' => ['status' => Devices::ACTIVE]]);

        if (!count($devices)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the device first") . ': ' . $this->tag->linkTo('admin/devices/add', __('Add')));
        }

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Redirects') . ' / ' . __('Add'));
        $this->view->pick('redirects/write');
        $this->view->setVars([
            'devices' => $devices,
            'status' => Redirects::status(true),
            'type' => Redirects::type(true),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $redirect = new Redirects();
            $redirect->setDevices($devices);
            $valid = $redirect->write();

            // Check if data are valid
            if ($valid instanceof Redirects) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        }
    }

    /**
     * Delete action - delete the redirect
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $redirect = Redirects::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($redirect->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/redirects'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($redirect->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display redirect's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $redirect = Redirects::findFirst($params[0])) {
            $this->tag->setTitle(__('Redirects') . ' / ' . __('Details'));
            $this->view->setVars([
                'redirect' => $redirect,
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the redirect
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $redirect = Redirects::findFirst($params[0])) {
            $devices = Devices::find(['status=:status:', 'bind' => ['status' => Devices::ACTIVE]]);

            if (!count($devices)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the device first") . ': ' . $this->tag->linkTo('admin/devices/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Redirects') . ' / ' . __('Edit'));
            $this->view->pick('redirects/write');
            $this->view->setVars([
                'devices' => $devices,
                'status' => Redirects::status(true),
                'type' => Redirects::type(true),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $redirect->setDevices($devices);
                $valid = $redirect->write('update');

                // Check if data are valid
                if ($valid instanceof Redirects) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                $diff = [
                    'device' => $redirect->device_id,
                ];
                // Values to fill out the form
                $this->tag->setDefaults(array_merge(get_object_vars($redirect), $diff));
            }
        } else {
            parent::notFoundAction();
        }
    }

}
