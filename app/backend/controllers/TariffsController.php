<?php

namespace Las\Backend\Controllers;

use Las\Models\Networks;
use Las\Models\Tariffs;
use Phalcon\Paginator\Adapter\Model as Paginator;

/**
 * Backend Tariffs Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class TariffsController extends IndexController
{

    /**
     * Index action - display all tariffs
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Tariffs'));
        // Available sort to choose
        $this->filter->add('in_array', function($value) {
            return in_array($value, ['amount', 'amount DESC', 'downloadCeil', 'downloadCeil DESC', 'name', 'name DESC', 'priority', 'priority DESC', 'uploadCeil', 'uploadCeil DESC']) ? $value : null;
        });

        // Get tariffs and prepare pagination
        $paginator = new Paginator([
            "data" => Tariffs::find(['order' => $this->request->getQuery('order', 'in_array', 'id', true)]),
            "limit" => $this->request->getQuery('limit', 'int', 20, true),
            "page" => $this->request->getQuery('page', 'int', 1, true)
        ]);

        $this->view->setVars([
            'pagination' => $paginator->getPaginate(),
            'bitRate' => \Las\Models\Settings::options('bitRate', $this->las['general']['bitRate']),
        ]);
    }

    /**
     * Add action - add the new tariff
     *
     * @package     las
     * @version     1.0
     */
    public function addAction()
    {
        $networks = Networks::find(['type=:type:', 'bind' => ['type' => Networks::WAN]]);

        if (!count($networks)) {
            $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the network first") . ': ' . $this->tag->linkTo('admin/networks/add', __('Add')));
        }

        // Set title, pick view and send variables
        $this->tag->setTitle(__('Tariffs') . ' / ' . __('Add'));
        $this->view->pick('tariffs/write');
        $this->view->setVars([
            'status' => Tariffs::status(true),
            'bitRate' => \Las\Models\Settings::options('bitRate', $this->las['general']['bitRate']),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            $tariff = new Tariffs();
            $valid = $tariff->write();

            // Check if data are valid
            if ($valid instanceof Tariffs) {
                unset($_POST);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        } else {
            $this->tag->setDefaults([
                'priority' => 50
            ]);
        }
    }

    /**
     * Delete action - delete the tariff
     *
     * @package     las
     * @version     1.0
     */
    public function deleteAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $tariff = Tariffs::findFirst($params[0])) {
            $this->view->pick('msg');

            if ($tariff->delete() == true) {
                // Display success flash and redirect
                $this->tag->setTitle(__('Success'));
                $this->view->setVars([
                    'title' => __('Success'),
                    'redirect' => 'admin/tariffs'
                ]);
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("Record has been deleted."));
            } else {
                // Display warning flash and log
                $this->tag->setTitle(__('Warning'));
                $this->view->setVars([
                    'title' => __('Warning'),
                    'content' => \Las\Bootstrap::log($tariff->getMessages())
                ]);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
            }
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Details action - display tariff's details
     *
     * @package     las
     * @version     1.0
     */
    public function detailsAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $tariff = Tariffs::findFirst($params[0])) {
            $this->tag->setTitle(__('Tariffs') . ' / ' . __('Details'));
            $this->view->setVars([
                'tariff' => $tariff,
                'bitRate' => \Las\Models\Settings::options('bitRate', $this->las['general']['bitRate']),
            ]);
        } else {
            parent::notFoundAction();
        }
    }

    /**
     * Edit action - edit the tariff
     *
     * @package     las
     * @version     1.0
     */
    public function editAction()
    {
        // Get id from url params and check if record exist
        $params = $this->router->getParams();
        if (isset($params[0]) && $tariff = Tariffs::findFirst($params[0])) {
            $networks = Networks::find(['type=:type:', 'bind' => ['type' => Networks::WAN]]);

            if (!count($networks)) {
                $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("Please add the network first") . ': ' . $this->tag->linkTo('admin/networks/add', __('Add')));
            }

            // Set title, pick view and send variables
            $this->tag->setTitle(__('Tariffs') . ' / ' . __('Edit'));
            $this->view->pick('tariffs/write');
            $this->view->setVars([
                'status' => Tariffs::status(true),
                'bitRate' => \Las\Models\Settings::options('bitRate', $this->las['general']['bitRate']),
            ]);

            // Check if the form has been sent
            if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
                $valid = $tariff->write('update');

                // Check if data are valid
                if ($valid instanceof Tariffs) {
                    $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                } else {
                    $this->view->setVar('errors', $valid);
                    $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
                }
            } else {
                // Values to fill out the form
                $this->tag->setDefaults(get_object_vars($tariff));
            }
        } else {
            parent::notFoundAction();
        }
    }

}
