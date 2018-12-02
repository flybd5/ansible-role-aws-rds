# ansible-role-aws-rds

### Ansible role to create and manage AWS RDS instances.

* Creates unlimited number of RDS
* Able to create one param group per RDS instance with custom settings
* Able to create one RDS subnet per RDS
* Able to gather VPC subnets for RDS subnets based on filters (tags)
* Idempotent

## Requirements

* Ansible 2.5+

## Role Variables

Additional variables that can be used (either as `host_vars`/`group_vars` or via command line args):

| Variable                 | Description                  |
|--------------------------|------------------------------|
| `aws_rds_profile`        | Boto profile name to be used |
| `aws_rds_default_region` | Default region to use        |

# Example Playbook

```yml
- hosts: localhost
  roles:
    - aws-rds
  vars:
    aws_rds_rdssubnet:
      - name: 'MyTestRDSSubnetGroup'
        region: 'eu-central-1'
        profile: 'playground'
        description: 'My test RDS subnet group'
        vpc_name: 'kubernetes-utilities'
        subnets:
          - filter:
            - key: 'tag:vpc-name'
              val: kubernetes-utilities
      - name: 'My Test RDS Subnet Group2'
        region: 'eu-central-1'
        profile: 'playground' (or set var aws_rds_profile)
        name: 'MyTestRDSSubnetGroup2'
        description: 'My test RDS subnet group number 2'
        vpc_tags:
          - key: 'tag:Name'
            val: my_test_vpc2
        subnets:
          - name: subnet-2-name
          - cidr: 10.0.11.0/24
          - filter:
            - key: 'tag:Name'
              val: my-subnet-4-name
```

## Filters when searching for subnets

Filters are applied to the search in a **logical AND** manner. In other words, if you specify two or more filters, only those subnets that pass **all** the filters will be returned.

* **availabilityZone** - The Availability Zone for the subnet. You can also use availability-zone as the filter name.
* **available-ip-address-count** - The number of IPv4 addresses in the subnet that are available.
* **cidrBlock** - The IPv4 CIDR block of the subnet. The CIDR block you specify must exactly match the subnet's CIDR block for information to be returned for the subnet. You can also use cidr or cidr-block as the filter names.
* **defaultForAz** - Indicates whether this is the default subnet for the Availability Zone. You can also use default-for-az as the filter name.
* **ipv6-cidr-block-association.ipv6-cidr-block** - An IPv6 CIDR block associated with the subnet.
* **ipv6-cidr-block-association.association-id** - An association ID for an IPv6 CIDR block associated with the subnet.
* **ipv6-cidr-block-association.state** - The state of an IPv6 CIDR block associated with the subnet.
* **state** - The state of the subnet (**pending | available**).
* **subnet-id** - The ID of the subnet.
* **tag:<key>** - The key/value combination of a tag assigned to the resource. Use the tag key in the filter name and the tag value as the filter value. For example, to find all resources that have a tag with the key Owner and the value TeamA, specify **tag:Owner** for the filter name and TeamA for the filter value.
* **tag-key** - The key of a tag assigned to the resource. Use this filter to find all resources assigned a tag with a specific key, regardless of the tag value.
* **vpc-id** - The ID of the VPC for the subnet. __DO NOT USE.__ **This filter is used by default in the role when searching for subnets for an RDS subnet, to ensure that all subnets to be used are included in the VPC that you specified.**

## Creating an RDS instances

You must already know which RDS subnet to use when creating an RDS instance.

```yml              
    aws_rds_rds:
      region: 'eu-central-1'
      profile: 'playground'
      instance_name: 'myTestRds'
      db_engine: 'MySQL'
      instance_type: 'db.t2.micro'
      username: 'SpongeBobSquarePants'
      password: '<something_best_kept_secret'
      size: 10
      subnet: 'MyTestRDSSubnetGroup'
      zone: 'eu-central-1c'
```

```yml
  aws_rds_rdsparamgroup:
    name: 'myRDSParamGroup'
    params:
      myFirstParam: 1
      mySecondParam: 'hello'
    engine: 'mySQL5.6'
```

# License

Apache 2.0
