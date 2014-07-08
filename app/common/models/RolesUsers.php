<?php

namespace Las\Models;

/**
 * User roles Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class RolesUsers extends \Phalcon\Mvc\Model
{

    /**
     * Roles Users initialize
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        $this->belongsTo('user_id', __NAMESPACE__ . '\Users', 'id', array(
            'alias' => 'User',
            'foreignKey' => true
        ));
        $this->belongsTo('role_id', __NAMESPACE__ . '\Roles', 'id', array(
            'alias' => 'Role',
            'foreignKey' => true
        ));
    }

}
