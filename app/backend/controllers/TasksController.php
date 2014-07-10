<?php

namespace Las\Backend\Controllers;

use Las\Models\Firewalls;
use Las\Models\Tasks;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Tasks Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class TasksController extends IndexController
{

    /**
     * Index action - display all tasks
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Tasks'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['name', 'name DESC', 'status', 'status DESC', 'type', 'type DESC', 'when', 'when DESC']) ? $value : null;
        });

        // Get tasks and prepare pagination
        $paginator = new Paginator([
            "data" => Tasks::find(['order' => $this->request->getQuery('order', 'in_array', 'id', true)]),
            "limit" => $this->request->getQuery('limit', 'int', 20, true),
            "page" => $this->request->getQuery('page', 'int', 1, true)
        ]);

        $this->view->setVars([
            'pagination' => $paginator->getPaginate(),
        ]);
    }

    /**
     * Add action - add the new task
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $firewalls = Firewalls::find();

        if (!count($firewalls)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the firewall first") . ': ' . $this->tag->linkTo('admin/firewalls/add', __('Add')));
        }

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Tasks') . ' / ' . __('Add'));
        $this->view->pick('tasks/write');
        $this->view->setVars([
            'type' => Tasks::type(true),
            'status' => Tasks::status(true),
            'firewalls' => $firewalls,
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $task = new Tasks();
            $task->__set('firewalls', $firewalls);
            $valid = $task->write();

            // Check if data are valid
            if ($valid instanceof Tasks) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        }
    }

    /**
     * Delete action - delete the task
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $task = Tasks::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($task->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/tasks'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($task->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display task's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $task = Tasks::findFirst($params[0])) {
            $this->tag->setTitle(__('Tasks') . ' / ' . __('Details'));
            $this->view->setVars([
                'task' => $task,
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the task
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $task = Tasks::findFirst($params[0])) {
            $firewalls = Firewalls::find();

            if (!count($firewalls)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the firewall first") . ': ' . $this->tag->linkTo('admin/firewalls/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Tasks') . ' / ' . __('Edit'));
            $this->view->pick('tasks/write');
            $this->view->setVars([
                'type' => Tasks::type(true),
                'status' => Tasks::status(true),
                'firewalls' => $firewalls,
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $task->__set('firewalls', $firewalls);
                $valid = $task->write('update');

                // Check if data are valid
                if ($valid instanceof Tasks) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                $diff = [
                    'firewall' => $task->firewall_id,
                    'next' => $task->next ? date('Y-m-d H:i', $task->next) : null
                ];
                // Values to fill out the form
                $this->tag->setDefaults(array_merge(get_object_vars($task), $diff));
            }
        } else {
            parent::notFoundAction();
        }
    }

}
