<?php

namespace Las\Backend\Controllers;

use Las\Models\Clients;
use Las\Models\Payments;
use Las\Models\Tariffs;
use Phalcon\Paginator\Adapter\NativeArray as Paginator;

/**
 * Backend Clients Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class ClientsController extends IndexController
{

    /**
     * Index action - display all clients
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Clients'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, [ 'address', 'address DESC', 'balance', 'balance DESC', 'fullName', 'fullName DESC', 'status', 'status DESC']) ? $value : null;
        });

        // Check if limit to client's status
        $status = $this->request->getQuery('status', 'int', null, true);
        if ($status !== null) {
            $data = $this->db->fetchAll('SELECT *, (SELECT sum(amount) FROM payments WHERE payments.client_id = clients.id AND payments.status = ' . Payments::SUCCESS . ') AS balance FROM clients WHERE status=:status ORDER BY ' . $this->request->getQuery('order', 'in_array', 'id', true), \Phalcon\Db::FETCH_OBJ, ['status' => $status]);
        } else {
            $data = $this->db->fetchAll('SELECT *, (SELECT sum(amount) FROM payments WHERE payments.client_id = clients.id AND payments.status = ' . Payments::SUCCESS . ') AS balance FROM clients ORDER BY ' . $this->request->getQuery('order', 'in_array', 'id', true), \Phalcon\Db::FETCH_OBJ);
        }

        // Get clients, their balance and prepare pagination
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
     * Add action - add the new client
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $tariffs = Tariffs::find('status=' . Tariffs::ACTIVE);

        if (!count($tariffs)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the tariff first") . ': ' . $this->tag->linkTo('admin/tariffs/add', __('Add')));
        }

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Clients') . ' / ' . __('Add'));
        $this->view->pick('clients/write');
        $this->view->setVars([
            'tariffs' => $tariffs,
            'status' => Clients::status(true),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $client = new Clients();
            $client->setTariffs($tariffs);
            $valid = $client->write();

            // Check if data are valid
            if ($valid instanceof Clients) {
                $_POST = [];
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        }
    }

    /**
     * Delete action - delete the client
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $client = Clients::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($client->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/clients'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($client->getMessages()),
                    'redirect' => false
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display client's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $client = Clients::findFirst($params[0])) {
            $this->tag->setTitle(__('Clients') . ' / ' . __('Details'));
            $this->view->setVars([
                'client' => $client,
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the client
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $client = Clients::findFirst($params[0])) {
            $tariffs = Tariffs::find(['status=:status:', 'bind' => ['status' => Tariffs::ACTIVE]]);

            if (!count($tariffs)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the tariff first") . ': ' . $this->tag->linkTo('admin/tariffs/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Clients') . ' / ' . __('Edit'));
            $this->view->pick('clients/write');
            $this->view->setVars([
                'tariffs' => $tariffs,
                'status' => Clients::status(true),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $client->setTariffs($tariffs);
                $valid = $client->write('update');

                // Check if data are valid
                if ($valid instanceof Clients) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                // Values to fill out the form
                $this->tag->setDefaults([
                    'fullName' => $client->fullName,
                    'address' => $client->address,
                    'tariff' => $client->tariff_id,
                    'description' => $client->description,
                    'status' => $client->status,
                ]);
            }
        } else {
            parent::notFoundAction();
        }
    }

}
