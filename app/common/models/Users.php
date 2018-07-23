<?php

namespace Las\Models;

use Las\Library\Auth;
use Las\Library\Email;

/**
 * User Model
 *
 * @package     las
 * @category    Model
 * @version     1.0
 */
class Users extends \Phalcon\Mvc\Model
{

    /**
     * User initialize
     *
     * @package     las
     * @version     1.0
     */
    public function onConstruct()
    {
        $this->hasMany('id', __NAMESPACE__ . '\Tokens', 'user_id', array(
            'alias' => 'Tokens',
            'foreignKey' => array(
                'action' => \Phalcon\Mvc\Model\Relation::ACTION_CASCADE
            )
        ));
        $this->hasMany('id', __NAMESPACE__ . '\RolesUsers', 'user_id', array(
            'alias' => 'Roles',
            'foreignKey' => array(
                'action' => \Phalcon\Mvc\Model\Relation::ACTION_CASCADE
            )
        ));
    }

    /**
     * Activation User method
     *
     * @package     las
     * @version     1.0
     */
    public function activation($role = 'login')
    {
        if ($this->getRole($role)) {
            // This user has login role, activation has already been completed
            return NULL;
        } else {
            // Add login role
            $userRole = new RolesUsers();
            $userRole->user_id = $this->id;
            $userRole->role_id = Roles::findFirst('name="' . $role . '"')->id;

            if ($userRole->create() === true) {
                return TRUE;
            } else {
                \Las\Bootstrap::log($this->getMessages());
                return $this->getMessages();
            }
        }
    }

    /**
     * Get user's role relation
     *
     * @package     las
     * @version     1.0
     *
     * @param string $role role to get one RolesUsers
     */
    public function getRole($role = 'login')
    {
        $role = Roles::findFirst(array('name=:role:', 'bind' => array(':role' => $role)));
        // Return null if role does not exist
        if (!$role) {
            return null;
        }
        // Return the role if user has the role otherwise false
        return $this->getRoles(array('role_id=:role:', 'bind' => array(':role' => $role->id)))->getFirst();
    }

    /**
     * Sign up User method
     *
     * @version     1.0
     */
    public function signup($role = 'login')
    {
        $validation = new \Las\Extension\Validation();

        $validation->add('username', new \Phalcon\Validation\Validator\PresenceOf());
        $validation->add('username', new \Las\Extension\Uniqueness(array(
            'model' => '\Las\Models\Users',
        )));
        $validation->add('username', new \Phalcon\Validation\Validator\StringLength(array(
            'min' => 4,
            'max' => 24,
        )));
        $validation->add('password', new \Phalcon\Validation\Validator\PresenceOf());
        $validation->add('repeatPassword', new \Phalcon\Validation\Validator\Confirmation(array(
            'with' => 'password',
        )));
        $validation->add('email', new \Phalcon\Validation\Validator\PresenceOf());
        $validation->add('email', new \Phalcon\Validation\Validator\Email());
        $validation->add('email', new \Las\Extension\Uniqueness(array(
            'model' => '\Las\Models\Users',
        )));
        $validation->add('repeatEmail', new \Phalcon\Validation\Validator\Confirmation(array(
            'with' => 'email',
        )));

        $validation->setLabels(array('username' => __('Username'), 'password' => __('Password'), 'repeatPassword' => __('Repeat password'), 'email' => __('Email'), 'repeatEmail' => __('Repeat email')));
        $messages = $validation->validate($_POST);

        if (count($messages)) {
            return $validation->getMessages();
        } else {
            $this->username = $this->getDI()->getShared('request')->getPost('username');
            $this->password = Auth::instance()->hash($this->getDI()->getShared('request')->getPost('password'));
            $this->email = $this->getDI()->getShared('request')->getPost('email');
            $this->logins = 0;

            if ($this->create() === true) {
                if ($role == 'admin') {
                    return $this;
                } else {
                    $hash = md5($this->id . $this->email . $this->password . $this->getDI()->getShared('config')->auth->hash_key);

                    $email = new Email();
                    $email->prepare(__('Activation'), $this->getDI()->getShared('request')->getPost('email'), 'activation', array('username' => $this->getDI()->getShared('request')->getPost('username'), 'hash' => $hash));

                    if ($email->Send() === true) {
                        $_POST = [];
                        return true;
                    } else {
                        \Las\Bootstrap::log($email->ErrorInfo);
                        return false;
                    }
                }
            } else {
                \Las\Bootstrap::log($this->getMessages());
                return $this->getMessages();
            }
        }
    }

}
