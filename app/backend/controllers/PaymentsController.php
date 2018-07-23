<?php

namespace Las\Backend\Controllers;

use Las\Models\Clients;
use Las\Models\Payments;
use Phalcon\Paginator\Adapter\NativeArray as Paginator;

/**
 * Backend Payments Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class PaymentsController extends IndexController
{

    /**
     * Index action - display all payments
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Payments'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['client', 'client DESC', 'date', 'date DESC', 'description', 'description DESC', 'amount', 'amount DESC', 'status', 'status DESC']) ? $value : null;
        });

        // Check if limit to client's payments
        if ($client = $this->request->getQuery('client', 'int', null, true)) {
            $data = $this->db->fetchAll('SELECT *, (SELECT fullName FROM clients WHERE clients.id = payments.client_id) AS client FROM payments WHERE client_id = :client ORDER BY ' . $this->request->getQuery('order', 'in_array', 'id', true), \Phalcon\Db::FETCH_OBJ, ['client' => $client]);
        } else {
            $data = $this->db->fetchAll('SELECT *, (SELECT fullName FROM clients WHERE clients.id = payments.client_id) AS client FROM payments ORDER BY ' . $this->request->getQuery('order', 'in_array', 'id', true), \Phalcon\Db::FETCH_OBJ);
        }

        // Get payments, client and prepare pagination
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
     * Add action - add the new payment
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $clients = Clients::find(['status!=:status:', 'bind' => ['status' => Clients::UNACTIVE]]);

        if (!count($clients)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the client first") . ': ' . $this->tag->linkTo('admin/clients/add', __('Add')));
        }

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Payment') . ' / ' . __('Add'));
        $this->view->pick('payments/write');
        $this->view->setVars([
            'clients' => $clients,
            'status' => Payments::status(true),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $payment = new Payments();
            $payment->__set('clients', $clients);
            $valid = $payment->write();

            // Check if data are valid
            if ($valid instanceof Payments) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        } else {
            $this->tag->setDefaults([
                'status' => Payments::SUCCESS,
            ]);
        }
    }

    /**
     * Delete action - delete the payment
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $payment = Payments::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($payment->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/payments'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($payment->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display payment's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $payment = Payments::findFirst($params[0])) {
            $this->tag->setTitle(__('Payments') . ' / ' . __('Details'));
            $this->view->setVars([
                'payment' => $payment,
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the payment
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $payment = Payments::findFirst($params[0])) {
            $clients = Clients::find(['status!=:status:', 'bind' => ['status' => Clients::UNACTIVE]]);

            if (!count($clients)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the client first") . ': ' . $this->tag->linkTo('admin/clients/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Payment') . ' / ' . __('Edit'));
            $this->view->pick('payments/write');
            $this->view->setVars([
                'clients' => $clients,
                'status' => Payments::status(true),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $payment->setClients($clients);
                $valid = $payment->write('update');

                // Check if data are valid
                if ($valid instanceof Payments) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                $diff = [
                    'client' => $payment->client_id,
                ];
                // Values to fill out the form
                $this->tag->setDefaults(array_merge(get_object_vars($payment), $diff));
            }
        } else {
            parent::notFoundAction();
        }
    }

}
