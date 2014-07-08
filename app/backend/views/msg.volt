{# Messages View | las | 1.0 #}
<div>
    <h2>{{ title|default(getTitle(false)) }}</h2><hr />
    {% if redirect !== false %}
        <meta http-equiv="Refresh" content="5; url={{ config.app.base_uri ~ redirect|default('') }}" />
    {% endif %}
    {{ flashSession.output() }}
    {{ content|default('') }}
</div>