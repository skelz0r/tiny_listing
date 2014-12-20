class SuckRepository
  include Interactor

  def call
    vacuum = Vacuum::Engine.new(context.repository)

    if vacuum.valid?
      vacuum.suck_up!
    else
      context.fail!(message: "Link isn't a valid repository")
    end
  end
end
