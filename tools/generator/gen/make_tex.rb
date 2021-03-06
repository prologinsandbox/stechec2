<% # -*- ruby -*-
#
# Stechec project is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# The complete GNU General Public Licence Notice can be found as the
# `NOTICE' file in the root directory.
#
# Copyright (C) 2005, 2006, 2007 Prologin
#

#
# Cree un fichier .tex, contenant la documentation de l'api, decrit par
# un fichier YAML
# Appel� depuis generator.rb
#

require "gen/file_generator.rb"

install_path = Pathname.new($install_path)

# fake IO stream for print_proto
class FakeIO
  def print(*s)
    s.each do |x|
      $erbout_ += x
    end
  end
  def puts(*s)
    s.each do |x|
      $erbout_ += x + "\n"
    end
  end
end

class CPrintProto < CProto
  def initialize
    @f = FakeIO.new
    super
  end

  def print_empty_arg
  end
end
$gen = CPrintProto.new

# les _ ont besoin d'etre echappe en latex
def esc(str)
  return "" unless str
  str.gsub(/_/, '\_')
end

#
# gere les balises commencant par doc_
#
def make_doc(sec)
  ret = true
  sec.each do |key, value|
    case key
    when "doc_extra"
      $erbout_ += esc(value)
    else
      ret = false
    end
  end
  return ret
end
%>

%%
%% This file was generated using gen/make_tex.rtex
%% Do not modify unless you are absolutely sure of what you are doing
%%

<%
#'
$conf["constant"].each do |f|
   next if make_doc f

   if f['cst_comment']
%>

\noindent \begin{tabular}{lp{11cm}}
\textbf{Constante:} & <%= esc(f['cst_name']) %> \\
\textbf{Valeur:} & <%= f['cst_val'] %> \\
\textbf{Description:} & <%= esc(f['cst_comment']) %> \\
\end{tabular}
\vspace{0.2cm} \\

<%
   end
end
%>

<%
$conf["enum"].each do |e|
    next if make_doc e
%>

\functitle{<%= esc(e['enum_name']) %>} \\
\noindent
\begin{tabular}[t]{@{\extracolsep{0pt}}>{\bfseries}lp{10cm}}
Description~: & <%= esc(e['enum_summary']) %> \\
Valeurs~: &
\small
\begin{tabular}[t]{@{\extracolsep{0pt}}lp{7cm}}
    <% e['enum_field'].each do |f| %>
        \textsl{<%= esc(f[0].upcase) %>}~: & <%= esc(f[1]) %> \\
    <% end %>
\end{tabular} \\
\end{tabular}

<%
end
%>

<%
$conf["struct"].each do |s|
    next if make_doc s
%>

\functitle{<%= esc(s['str_name']) %>}

\begin{lst-c++}
struct <%= s['str_name'] %> {<% s['str_field'].each do |f| %>
    <%= f[1] %> <%= f[0] %>;<% end %>
};
\end{lst-c++}

\noindent
\begin{tabular}[t]{@{\extracolsep{0pt}}>{\bfseries}lp{10cm}}
Description~: & <%= esc(s['str_summary']) %> \\
Champs~: &
\small
\begin{tabular}[t]{@{\extracolsep{0pt}}lp{7cm}}
    <% s['str_field'].each do |f| %>
        \textsl{<%= esc(f[0]) %>}~: & <%= esc(f[2]) %> \\
    <% end %>
\end{tabular} \\
\end{tabular}

<%
end
%>

<%
($conf["function"]).each do |f|
  next if make_doc f
%>
\begin{minipage}{\linewidth}
\functitle{<%= esc(f['fct_name']) %>}

\begin{lst-c++}
<%= $gen.print_proto(f['fct_name'], f['fct_ret_type'], f['fct_arg']) %>
\end{lst-c++}

\noindent
\begin{tabular}[t]{@{\extracolsep{0pt}}>{\bfseries}lp{10cm}}
Description~: & <%= esc(f['fct_summary']) %> \\

<% if f['fct_arg_comment'] or f['fct_arg'] and f['fct_arg'].any? { |arg| arg[2] } %>
Parametres~: &
\begin{tabular}[t]{@{\extracolsep{0pt}}ll}
    <% if f['fct_arg_comment'] %>
      \multicolumn{2}{l}{\hspace{-\tabcolsep} <%= esc(f['fct_arg_comment']) %> \\
    <% end %>
    <% f['fct_arg'].each do |arg| %>
      <% if arg[2] %>
        \textsl{<%= esc(arg[0]) %>}~: & <%= esc(arg[2]) %> \\
      <% end %>
    <% end %>
  \end{tabular} \\
<% end %>

<% if f['fct_ret_comment'] %>
Retour~: & <%= esc(f['fct_ret_comment']) %> \\
<% end %>

<% if f['fct_notice'] %>
Remarques~: & <%= esc(f['fct_notice']) %> \\
<% end %>

\end{tabular} \\[0.3cm]
\end{minipage}

<% end %>
