const amplifyConfig = r'''{
  "auth": {
    "user_pool_id": "us-east-2_JJMTvTYzn",
    "aws_region": "us-east-2",
    "user_pool_client_id": "1el321i80j9b5ja95m3q4b51dq",
    "identity_pool_id": "us-east-2:4ea69529-c305-4b25-b2ae-ad7edbb8d309",
    "mfa_methods": [],
    "standard_required_attributes": [
      "email"
    ],
    "username_attributes": [
      "email"
    ],
    "user_verification_types": [
      "email"
    ],
    "groups": [],
    "mfa_configuration": "NONE",
    "password_policy": {
      "min_length": 8,
      "require_lowercase": true,
      "require_numbers": true,
      "require_symbols": true,
      "require_uppercase": true
    },
    "unauthenticated_identities_enabled": true
  },
  "version": "1.5"
}''';