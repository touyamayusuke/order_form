# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
ApplicationRecord.transaction do
  Order.delete_all
  PaymentMethod.delete_all
  InflowSource.delete_all
  Product.delete_all

  PaymentMethod.create(id: 1, name: 'クレジットカード')
  PaymentMethod.create(id: 2, name: '銀行振込')
  PaymentMethod.create(id: 3, name: '代引き')
  PaymentMethod.create(id: 4, name: 'コンビニ払い')
  PaymentMethod.create(id: 5, name: 'PayPal')

  InflowSource.create(id: 1, name: '検索エンジン')
  InflowSource.create(id: 2, name: 'SNS')
  InflowSource.create(id: 3, name: '友人・知人')
  InflowSource.create(id: 4, name: '広告')
  
  Product.create(id: 1, name: '商品A', price: 100)
  Product.create(id: 2, name: '商品B', price: 200)
  Product.create(id: 3, name: '商品C', price: 300)
  Product.create(id: 4, name: '商品D', price: 400)
  Product.create(id: 5, name: '商品E', price: 500)
  Product.create(id: 6, name: '商品F', price: 600)
end