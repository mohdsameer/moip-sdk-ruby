# Tip: This setup section generally goes in other files,
# and you access them in your controllers as globals,
# instead of reinstantiating them every time.
gem "moip2"

auth = Moip2::Auth::Basic.new("TOKEN", "SECRET")

client = Moip2::Client.new(:sandbox, auth)

api = Moip2::Api.new(client)

# If you want to persist your customer data and save later, now is
# the time to create it.
# TIP: Don't forget to generate your `own_id` or use one you already have

customer = api.customer.create(
  ownId: "meu_cliente_id_#{SecureRandom.hex(10)}",
  fullname: "Integração Moip",
  email: "integracaomoip@moip.com.br",
  taxDocument: {
    type: "CPF",
    number: "22222222222",
  },
  phone: {
    countryCode: "55",
    areaCode: "11",
    number: "66778899",
  },
  shippingAddress: {
    city: "Sao Paulo",
    complement: "8",
    district: "Itaim",
    street: "Avenida Faria Lima",
    streetNumber: "2927",
    zipCode: "01234000",
    state: "SP",
    country: "BRA",
  },
)

# Creating a credit card for a customer
customer_credit_card = api.customer.add_credit_card(
  customer.id,
  method: "CREDIT_CARD",
  creditCard: {
    expirationMonth: "05",
    expirationYear: "22",
    number: "5555666677778884",
    cvc: "123",
    holder: {
      fullname: "Jose Portador da Silva",
      birthdate: "1988-12-30",
      taxDocument: {
        type: "CPF",
        number: "33333333333",
      },
      phone: {
        countryCode: "55",
        areaCode: "11",
        number: "66778899",
      },
    },
  },
)

# TIP: Now you can access the Moip ID to save it to your database, if you want
# Ex.:
# Customer.find_by(id: 123).update!(moip_id: customer.id)

# Here we build the order data. You'll get the data from your database
# given your controller input, but here we simplify things with a hardcoded
# example

order = api.order.create(
  own_id: "meu_id_de_order_#{SecureRandom.hex(10)}",
  items: [
    {
      product: "Nome do produto",
      quantity: 1,
      detail: "Mais info...",
      price: 1000,
    },
  ],
  customer: {
    id: customer.id,
  },
)

payment = api.payment.create(
  order.id,
  installment_count: 1,
  funding_instrument: {
    method: "CREDIT_CARD",
    credit_card: {
      id: customer_credit_card.credit_card.id,
      holder: {
        fullname: "Integração Moip",
        birthdate: "1988-12-30",
        taxDocument: {
          type: "CPF",
          number: "33333333333",
        },
        phone: {
          countryCode: "55",
          areaCode: "11",
          number: "000000000",
        },
      },
    },
  },
)

# You can create a full payment refunds:
full_payment_refund = api.refund.create(payment.id)

# TIP: To get your application synchronized to Moip's platform,
# you should have a route that handles Webhooks.
# For further information on the possible webhooks, please refer to the official docs
# (https://dev.moip.com.br/v2.0/reference#lista-de-webhooks-disponíveis)
