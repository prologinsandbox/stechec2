<% # -*- ruby -*-
#
# Stechec project is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# The complete GNU General Public Licence Notice can be found as the
# `COPYING' file in the root directory.
#
# Copyright (C) 2005, 2006, 2007 Prologin
#

#
# Cree un fichier .rst, contenant la documentation de l'api, decrit par
# un fichier YAML
# Appelé depuis generator.rb
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

#
# gere les balises commencant par doc_
#
def make_doc(sec)
  ret = true
  sec.each do |key, value|
    case key
    when "doc_extra"
      $erbout_ += value
    else
      ret = false
    end
  end
  return ret
end
%>

===
API
===

..
   This file was generated using gen/make_sphinx.rsphinx
   Do not modify unless you are absolutely sure of what you are doing

Constantes
==========

<%

$conf["constant"].each do |f|
   next if make_doc f

   if f['cst_comment']
%>
.. c:var:: <%= f['cst_name'] %>

  :Valeur: <%= f['cst_val'] %>
  :Description:
    <%= f['cst_comment'] %>

    <% end %>
<% end %>

Énumérations
============

<%
$conf["enum"].each do |e|
    next if make_doc e
%>

.. c:type:: <%= e['enum_name'] %>

  :Description:
      <%= e['enum_summary'] %>
  :Valeurs:
    <% e['enum_field'].each do |f| %>
      :<%= f[0].upcase %>:
        <%= f[1] %>

    <% end %>
<% end %>

Structures
==========

<%
$conf["struct"].each do |s|
    next if make_doc s
%>

.. c:type:: <%= s['str_name'] %>

  .. code-block:: c

    struct <%= s['str_name'] %> {<% s['str_field'].each do |f| %>
        <%= f[1] %> <%= f[0] %>;<% end %>
    };

  :Description: <%= s['str_summary'] %>

  :Champs:
    <% s['str_field'].each do |f| %>:<%= f[0] %>: <%= f[2] %>
    <% end %>
<% end %>

Fonctions
=========

<%
($conf["function"]).each do |f|
  next if make_doc f
%>

.. c:function:: <%= $gen.print_proto(f['fct_name'], f['fct_ret_type'], f['fct_arg']) %>

    <%= f['fct_summary'] %>

    <% if f['fct_notice'] %>
    :Remarques: <%= f['fct_notice'] %>
    <% end %>

<% if f['fct_arg_comment'] or f['fct_arg'] and f['fct_arg'].any? { |arg| arg[2] } %>
    <% if f['fct_arg_comment'] %>
    <%= f['fct_arg_comment'] %>
    <% end %>

    <% f['fct_arg'].each do |arg| %>
      <% if arg[2] %>
    :param <%= arg[0] %>: <%= arg[2] %>
      <% end %>
    <% end %>
<% end %>

  <% if f['fct_ret_comment'] %>
  :rtype: <%= f['fct_ret_comment'] %>
  <% end %>
<% end %>

Fonctions utilisateur
=====================

<%
($conf["user_function"]).each do |f|
  next if make_doc f
%>

.. c:function:: <%= $gen.print_proto(f['fct_name'], f['fct_ret_type'], f['fct_arg']) %>

    <%= f['fct_summary'] %>

    <% if f['fct_notice'] %>
    :Remarques: <%= f['fct_notice'] %>
    <% end %>

<% if f['fct_arg_comment'] or f['fct_arg'] and f['fct_arg'].any? { |arg| arg[2] } %>
    <% if f['fct_arg_comment'] %>
    <%= f['fct_arg_comment'] %>
    <% end %>

    <% f['fct_arg'].each do |arg| %>
      <% if arg[2] %>
    :param <%= arg[0] %>: <%= arg[2] %>
      <% end %>
    <% end %>
<% end %>

  <% if f['fct_ret_comment'] %>
  :rtype: <%= f['fct_ret_comment'] %>
  <% end %>
<% end %>
