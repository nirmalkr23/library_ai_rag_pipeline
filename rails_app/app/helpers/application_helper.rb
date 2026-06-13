module ApplicationHelper
  def auth_input_classes
    "block w-full rounded-lg border border-slate-300 px-3.5 py-2.5 text-slate-900 " \
      "placeholder:text-slate-400 shadow-sm focus:border-indigo-500 focus:ring-2 " \
      "focus:ring-indigo-500/30 focus:outline-none transition"
  end

  def auth_button_classes
    "w-full rounded-lg bg-indigo-600 px-4 py-2.5 font-semibold text-white shadow-sm " \
      "hover:bg-indigo-700 focus:ring-2 focus:ring-indigo-500/50 focus:outline-none " \
      "transition cursor-pointer"
  end
end
