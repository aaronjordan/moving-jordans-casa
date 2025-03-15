class ClaimEventMailer < ApplicationMailer
  default cc: User.where(is_admin: true).pluck(:email_address)

  def success_notification(claim)
    @item = claim.item
    @user = claim.user
    mail(to: @user.email_address, subject: "Congrats! You've claimed #{@item.title} from the Jordans' giveaway.")
  end
end
