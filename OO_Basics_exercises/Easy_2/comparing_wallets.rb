# Comparing Wallets

# Consider the following broken code. Modify the code so it works. Do not make the amount in the wallet accessible to any method that isn't part of the Wallet class.

class Wallet
  include Comparable

  protected attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def <=>(other_wallet)
    amount <=> other_wallet.amount  # requires a getter
  end
end

bills_wallet = Wallet.new(500)
pennys_wallet = Wallet.new(465)
if bills_wallet > pennys_wallet
  puts 'Bill has more money than Penny'
elsif bills_wallet < pennys_wallet
  puts 'Penny has more money than Bill'
else
  puts 'Bill and Penny have the same amount of money.'
end