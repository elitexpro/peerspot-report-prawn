class PdfViewController < ApplicationController
  def index
    pdf = Prawn::Document.new(
      page_size: 'B5',
      page_layout: :portrait,
      margin: 44
    )

    create_header(pdf, 'Valuable Features')

    create_line(pdf, 'When it comes to valuable features, the main features mentioned include:')

    create_list(pdf, 'Its breadth of capabilities')
    create_list(pdf, 'The ease of use')
    create_list(pdf, 'It follows ArchiMate principle')
    create_list(pdf, 'Its ability to scale and grow')
    create_list(pdf, 'The HoriZZon portal')
    create_list(pdf, 'Visualizations')
    create_list(pdf, 'Insights')

    create_line(pdf, 'What users had to say about valuable features:')

    param = {
      avatar: 'user-avatar-1.png',
      name: 'Olga Lucia Salgado',
      subtitle: 'Senior Enterprice Architect',
      feature: 'at a manufacturing company with 201-500 employees',
      recommendation: '“Its breadth of capabilities is very good from the modeling perspective, as it really covers all of the standards that we use in our company and even some that we haven\'t really used yet.”'
    }
    json_object = JSON.generate(param)

    create_feature(pdf, json_object)

    pdf.span(100, position: :center) do
      pdf.text(' - ' * 9)
    end

    param = {
      avatar: 'user-avatar-2.png',
      name: 'Bijoy Talukder',
      subtitle: 'Senior Enterprise Architect',
      feature: 'at a manufacturing company with 201-500 emmployees',
      recommendation: '“Once things are put in BiZZdesign, it is very easy to use.”'
    }
    json_object = JSON.generate(param)

    create_feature(pdf, json_object)

    create_footer(pdf)

    filename = Time.now.to_i.to_s

    file = File.join(Rails.root, "app/report", filename + '.pdf')
    pdf.render_file file

    send_file file, :file => filename, :type => "application/pdf", :disposition => 'inline'
  end

  private
  def create_header(pdf, text)
    pdf.font('Helvetica', style: :bold, size: 24)
    pdf.text text
    pdf.font('Helvetica', style: :normal, size: 12)
    pdf.move_down 20
  end

  def create_line(pdf, text)
    pdf.move_down 8
    pdf.text(text)
    pdf.move_down 8
  end

  def create_list(pdf, text)
    pdf.move_down 4
    ref = File.join(Rails.root, "app/assets/images", "green-check.png")
    pdf.image(ref)
    y_position = pdf.cursor + 4
    pdf.draw_text(text, at: [24, y_position])
    pdf.move_down 4
  end

  def create_feature(pdf, param)
    pdf.move_down 12

    params = JSON.parse(param)
    ref = File.join(Rails.root, "app/assets/images", params['avatar'])
    pdf.image(ref)

    y_position = pdf.cursor + 34

    pdf.font('Helvetica', style: :bold) do
      pdf.draw_text(params['name'], at: [60, y_position])
    end

    pdf.font('Helvetica') do
      pdf.draw_text(params['subtitle'], at: [60, y_position - 16], width: 300, height: 12, color: 'b4b4b4')
      pdf.draw_text(params['feature'], at: [60, y_position - 28], width: 300, height: 12, color: 'b4b4b4')
    end

    y_position = pdf.cursor - 24

    pdf.font('Helvetica') do
      pdf.text_box(params['recommendation'], at: [60, y_position], width: 300)
    end

    pdf.move_down 85
  end

  def create_footer(pdf)
    pdf.draw_text('©2023 PeerSpot', at: [0, -24])
    pdf.draw_text('3', at: [400, -24])
  end
end
