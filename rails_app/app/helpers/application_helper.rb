module ApplicationHelper
  def auth_input_classes
    "block w-full rounded-lg border border-white/10 bg-white/5 px-3.5 py-2.5 text-slate-100 " \
      "placeholder:text-slate-500 shadow-sm focus:border-indigo-400 focus:ring-2 " \
      "focus:ring-indigo-500/40 focus:outline-none transition"
  end

  def auth_button_classes
    "w-full rounded-lg bg-indigo-500 px-4 py-2.5 font-semibold text-white shadow-lg " \
      "shadow-indigo-500/20 hover:bg-indigo-400 focus:ring-2 focus:ring-indigo-500/50 " \
      "focus:outline-none transition cursor-pointer"
  end
end
