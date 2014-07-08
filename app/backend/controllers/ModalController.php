<?php

namespace Las\Backend\Controllers;

/**
 * Backend Modal Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class ModalController extends IndexController
{

    /**
     * Initialize - clear main view
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        // Load index Controller initialize first
        parent::initialize();

        // Disable main view, but layout modal exist and is loading
        $this->view->setMainView(null);
    }

    /**
     * Index Action - deleting confirmation
     *
     * @package     mateball
     * @version     2.0
     */
    public function indexAction()
    {
        $this->view->setVars([
            'modalTitle' => __('Are you sure?'),
            'modalAccept' => $this->tag->linkTo(['#', __('Delete'), 'class' => 'btn btn-danger', 'data-accept' => 'modal'])
        ]);
    }

    /**
     * Reload Action - reload confirmation
     *
     * @package     mateball
     * @version     2.0
     */
    public function reloadAction()
    {
        $this->view->setVars([
            'modalTitle' => __('Are you sure?'),
            'modalAccept' => $this->tag->linkTo(['#', __('Reload'), 'class' => 'btn btn-warning', 'data-accept' => 'modal'])
        ]);
    }

}
