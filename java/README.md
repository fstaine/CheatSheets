# Java


## Mapstruct

Create a mapper with a dependencie called manually:

```java
@Mapper(config = MappingConfiguration.class)
public abstract class ResolvedOrganizationMapper {

    @Setter(onMethod_ = {@Autowired})
    private EmailAddressBuilder emailAddressBuilder;

    @Mapping(target = "emailAddress", expression = "java(emailAddressMapper(organization))")
    public abstract ResolvedOrganization toResolvedOrganization(Organization organization)
        throws InvalidOrganizationException;

    protected InternetAddress emailAddressMapper(Organization organization) throws InvalidOrganizationException {
        try {
            return emailAddressBuilder.execute(organization.getCountryCode(),
                organization.getNationalId(),
                organization.getName()
            );
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new InvalidOrganizationException(organization, e);
        }
    }
}
```
