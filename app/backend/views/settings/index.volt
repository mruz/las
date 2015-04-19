<h3><span class="glyphicon glyphicon-cog"></span> {{ __('Settings') }} / {{ __(category|capitalize) }}</h3><hr />
{{ flashSession.output() }}
{{ form(null, 'class' : 'form-horizontal') }}
{% for setting in settings %}
    {% set field = setting.name %}
    {% if setting.type == settings__TEXT() %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
            <div class="col-lg-9">
                {{ textField([ field, 'class' : 'form-control', 'placeholder' : __(field|label) ]) }}
                {% if errors is defined and errors.filter(field) %}
                <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
    {% elseif setting.type == settings__PASSWORD() %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
            <div class="col-lg-9">
                {{ passwordField([ field, 'class' : 'form-control', 'placeholder' : __(field|label) ]) }}
                {% if errors is defined and errors.filter(field) %}
                <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
    
    {% elseif setting.type == settings__CHECK() %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
            <div class="col-lg-9">
                {{ checkField(_POST[field] is defined and _POST[field] == 1 ? [ field, 'value': 1, 'checked': 'checked' ] : [ field, 'value': 1 ]) }}
                {% if errors is defined and errors.filter(field) %}
                    <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
    {% elseif setting.type == settings__AREA() %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
            <div class="col-lg-9">
                {{ textarea([ field, 'class' : 'form-control', 'placeholder' : __(field|capitalize), 'rows':5 ]) }}
                {% if errors is defined and errors.filter(field) %}
                <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
    {% elseif setting.type == settings__SELECT() %}
        <div class="form-group{{ errors is defined and errors.filter(field) ? ' has-error' : (_POST[field]|isset ? ' has-success' : '') }}">
            <label class="control-label col-lg-3" for={{ field }}>{{ __(field|label) }}:</label>
            <div class="col-lg-9">
                {{ selectStatic([field, 'class': 'form-control', json_decode(setting.options, true)]) }}
                {% if errors is defined and errors.filter(field) %}
                    <span class="help-block">{{ current(errors.filter(field)).getMessage() }}</span>
                {% endif %}
            </div>
        </div>
    {% endif %}
{% endfor %}
<hr />
<div class="form-group">
    <div class="col-lg-offset-3 col-lg-9">
        <p><button type="submit" name="submit" class="btn btn-primary">{{ __('Save') }}</button></p>
    </div>
</div>
{{ endForm() }}