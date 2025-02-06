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

Use a mapper defined manually:

```java
@RequiredArgsConstructor
@Component
@Named("OrganizationCygognEmailAddressMapper")
public class OrganizationCygognEmailAddressMapper {

    private final CygognEmailAddressBuilder cygognEmailAddressBuilder;

    @Named("toCygognEmailAddress")
    public String toCygognEmailAddress(Organization organization)
        throws MessagingException, UnsupportedEncodingException {
        return cygognEmailAddressBuilder
            .execute(organization.getCountryCode(), organization.getNationalId(), organization.getName())
            .toUnicodeString();
    }
}

@Mapper(config = MappingConfiguration.class, uses = OrganizationCygognEmailAddressMapper.class)
public interface OrganizationCreatedEventMapper {

    @Mapping(source = "organization", target = "cygEmailAddr",
        qualifiedByName = {"OrganizationCygognEmailAddressMapper", "toCygognEmailAddress"})
    OrganizationCreatedEventMessage toEvent(Organization organization, List<Person> persons);
}

```
