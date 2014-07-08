<?php

namespace Las\Models;

/**
 * Role Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Roles extends \Phalcon\Mvc\Model
{

    /**
     * Role initialize
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        $this->hasMany('id', __NAMESPACE__ . '\RolesUsers', 'role_id', array(
            'alias' => 'RolesUsers',
        ));
    }

}
