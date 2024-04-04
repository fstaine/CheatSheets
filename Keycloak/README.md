# Keycloak

## FreeMarker

### Show an object properties

```injectedfreemarker
<#list realm?keys as key>
    <p>"${key}":"${kcSanitize(realm[key])}"</p>
</#list>
```
