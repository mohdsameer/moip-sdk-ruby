# Here is an example of creating an Moip account using the Moip account API

auth = Moip2::Auth::OAuth.new("502f9ca0eccc451dbcf8c0b940110af1_v2")

client = Moip2::Client.new(:sandbox, auth)

api = Moip2::Api.new(client)

account = api.accounts.create(
  email: {
    address: "dev.moip@labs.moip.com.br",
  },
  person: {
    name: "Joaquim José",
    lastName: "Silva Silva",
    taxDocument: {
      type: "CPF",
      number: "978.443.610-85",
    },
    identityDocument: {
      type: "RG",
      number: "35.868.057-8",
      issuer: "SSP",
      issueDate: "2000-12-12",
    },
    birthDate: "1990-01-01",
    phone: {
      countryCode: "55",
      areaCode: "11",
      number: "965213244",
    },
    address: {
      street: "Av. Brigadeiro Faria Lima",
      streetNumber: "2927",
      district: "Itaim",
      zipCode: "01234-000",
      city: "S\u00E3o Paulo",
      state: "SP",
      country: "BRA",
    },
  },
  type: "MERCHANT",
)
