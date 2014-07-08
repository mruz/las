<ul class="list-group">
    <li class="list-group-header">Menu</li>
    <li class="list-group-item{{ controller == 'index' ? ' active' : '' }}">{{ linkTo('admin', '<span class="glyphicon glyphicon-home"></span> ' ~ __('Admin panel')) }}</li>
    {% set field = 'clients' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-user"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'devices' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-phone"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'services' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-briefcase"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'redirects' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-random"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'messages' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-envelope"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'networks' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-globe"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'payments' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-usd"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'tariffs' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-sort-by-attributes-alt"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>

    <li class="list-group-header">{{ __('Advanced') }}</li>

    {% set field = 'firewalls' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-filter"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'tasks' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-time"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'add' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/add', __('Add')) }}</li>
            </ul>
        </div>
    </li>
    {% set field = 'settings' %}
    <li class="list-group-item{{ controller == field and action == 'index' ? ' active' : '' }}">
        <span class="caret dropdown-toggle" data-toggle="collapse" data-target="#nav-{{ field }}"></span>
        {{ linkTo('admin/' ~ field, '<span class="glyphicon glyphicon-cog"></span> ' ~ __(field|capitalize)) }}
        <div id="nav-{{ field }}" class="collapse">
            <ul role="menu" class="list-group-item-menu">
                <li class="list-group-item{{ controller == field and action == 'payments' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/payments', __('Payments')) }}</li>
                <li class="list-group-item{{ controller == field and action == 'qos' ? ' active' : '' }}">{{ linkTo('admin/' ~ field ~ '/qos', __('Qos')) }}</li>
            </ul>
        </div>
    </li>

    <li class="divider"></li>

    <li class="list-group-item">{{ linkTo('doc', '<span class="glyphicon glyphicon-book"></span> ' ~ __('Documentation')) }}</li>
    <li class="list-group-item">{{ linkTo('user/signout', '<span class="glyphicon glyphicon-log-out"></span> ' ~ __('Sign out')) }}</li>
</ul>