<?php

namespace Las\Backend\Controllers;

use Las\Models\Clients;
use Las\Models\Messages;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Messages Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class MessagesController extends IndexController
{

    /**
     * Index action - display all messages
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Messages'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['client_id', 'client_id DESC', 'content', 'contentt DESC', 'date', 'date DESC', 'status', 'status DESC', 'title', 'title DESC']) ? $value : null;
        });

        // Check if limit to client's messages
        if ($client = $this->request->getQuery('client', 'int', null, true)) {
            $data = Messages::find(['client_id = :client:', 'order' => $this->request->getQuery('order', 'in_array', 'id', true), 'bind' => ['client' => $client]]);
        } else {
            $data = Messages::find(['order' => $this->request->getQuery('order', 'in_array', 'id', true)]);
        }

        // Get messages and prepare pagination
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
     * Add action - add the new message
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
        $this->tag->setTitle(__('Messages') . ' / ' . __('Add'));
        $this->view->pick('messages/write');
        $this->view->setVars([
            'clients' => $clients,
            'status' => Messages::status(true),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $message = new Messages();
            $message->__set('clients', $clients);
            $valid = $message->add();

            // Check if data are valid
            if ($valid instanceof Messages || $valid === true) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        }
    }

    /**
     * Delete action - delete the message
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $message = Messages::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($message->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/messages'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($message->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display message's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $message = Messages::findFirst($params[0])) {
            $this->tag->setTitle(__('Messages') . ' / ' . __('Details'));
            $this->view->setVars([
                'message' => $message,
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the message
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $message = Messages::findFirst($params[0])) {
            $clients = Clients::find(['status!=:status:', 'bind' => ['status' => Clients::UNACTIVE]]);

            if (!count($clients)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the client first") . ': ' . $this->tag->linkTo('admin/clients/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Messages') . ' / ' . __('Edit'));
            $this->view->pick('messages/write');
            $this->view->setVars([
                'clients' => $clients,
                'status' => Messages::status(true),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $message->__set('clients', $clients);
                $valid = $message->edit();

                // Check if data are valid
                if ($valid instanceof Messages) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                $diff = [
                    'client' => $message->client_id
                ];
                // Values to fill out the form
                $this->tag->setDefaults(array_merge(get_object_vars($message), $diff));
            }
        } else {
            parent::notFoundAction();
        }
    }

}
