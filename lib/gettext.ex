use Croma

defmodule StackoverflowCloneG.Gettext do
  use Antikythera.Gettext, otp_app: :stackoverflow_clone_g

  defun put_locale(locale :: v[String.t]) :: nil do
    Gettext.put_locale(__MODULE__, locale)
  end
end
