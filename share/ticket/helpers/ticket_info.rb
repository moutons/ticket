module TicketInfo
  def root
    ENV['TICKET_ROOT'] || File.join(ENV['HOME'], 'support')
  end

  def load_ticket(opts = {})
    if opts[:id]
      filename = ticket_info_path(opts[:id])
    elsif opts[:file]
      filename = opts[:file]
    else
      raise "Did not specify an :id or :file to load"
    end

    @ticket = read_ticket_info(filename)
  end

  def read_ticket_info(filename)
    return unless File.exists?(filename)
    JSON.parse(File.read(filename))
  end

  def find_local_ticket_info
    %w{ ticket.info ../ticket.info }.each do |file|
      return file if File.exists?(file)
    end
    return nil
  end

  def full_ticket_info_path(client, id)
    File.join(root, client, id, 'ticket.info')
  end

  def ticket_info_path(id)
    path = File.join(linked_ticket_path, id, 'ticket.info')
    if File.exists?(path)
      File.realpath(path)
    else
      path
    end
  end

  def linked_ticket_path
    File.join(root, '.tickets')
  end

  def ticket_url
    "https://getchef.zendesk.com/agent/tickets/#{ticket['id']}"
  end

  def ticket_path
    File.dirname(ticket_info_path(ticket['id']))
  end

  def client_list
    Dir.entries(root).reject { |file| file[0] == '.' }
  end

  def all_ticket_ids
    Dir.entries(linked_ticket_path).reject { |file| file[0] == '.' }
  end

  def ticket_ids(client)
    Dir.entries(File.join(root, client)).reject { |file| file[0] == '.' }
  end
end