class PdfViewController < ApplicationController
  def index
    # Forked Data of Features
    features = [{
      key: 'Its breadth of capabilities',
      avatar: 'user-avatar-1.png',
      name: 'Olga Lucia Salgado',
      title: 'Senior Enterprice Architect',
      company_description: 'at a manufacturing company with 201-500 employees',
      recommendation: '“Its breadth of capabilities is very good from the modeling perspective, as it really covers all of the standards that we use in our company and even some that we haven\'t really used yet.”'
    }, {
      key: 'The ease of use',
      avatar: 'user-avatar-2.png',
      name: 'Bijoy Talukder',
      title: 'Senior Enterprise Architect',
      company_description: 'at a manufacturing company with 201-500 emmployees',
      recommendation: '“Once things are put in BiZZdesign, it is very easy to use.”'
    }, {
      key: 'It follows ArchiMate principle'
    }, {
      key: 'Its ability to scale and grow'
    }, {
      key: 'The HoriZZon portal'
    }, {
      key: 'Visualizations'
    }, {
      key: 'Insights'
    }]

    # Create Prawn Document
    pdf = Prawn::Document.new(
      page_size: 'A4',
      page_layout: :portrait,
      margin: 46
    )

    # Header of Report
    create_header(pdf, 'Valuable Features')

    # When it comes to valuable features, the main features mentioned include:
    pdf.move_down 16
    create_line(pdf, 'When it comes to valuable features, the main features mentioned include:')
    pdf.move_down 11

    features.each do |feature|
      create_check_list_item(pdf, feature[:key])
    end

    # What users had to say about valuable features:
    pdf.move_down 16
    create_line(pdf, 'What users had to say about valuable features:')
    pdf.move_down 16

    # Display only two features on the current page (this is a temparary setting according to the screenshot)
    ref = File.join(Rails.root, "app/assets/images", "feature-separator.png")
    (feature_count_to_display = 2).times do |i|
      create_feature(pdf, features[i])

      # Draw separator between features
      feature_count_to_display - 1 > i && pdf.span(300, position: :center) do
        pdf.image(ref)
        pdf.move_down 30
      end
    end

    # Footer of Report
    create_footer(pdf)

    # Generate and render the report file as PDF
    filename = Time.now.to_i.to_s

    file = File.join(Rails.root, "app/report", filename + '.pdf')
    pdf.render_file file

    send_file file, :file => filename, :type => "application/pdf", :disposition => 'inline'
  end

  private
  def create_header(pdf, text)
    pdf.bounding_box([-46, pdf.cursor + 25], :width => 0, :height => 50) do
      pdf.stroke_color 'FFFFFF'
      pdf.stroke do
          pdf.fill_color 'FFD700'
          pdf.fill_and_stroke_rectangle [0, pdf.cursor], 10, 50
          pdf.fill_color '000000'
      end
    end

    pdf.move_up 44
    pdf.rectangle [300,300], 100, 200
    pdf.font(Rails.root.join("app/assets/fonts/Martel-Black.ttf").to_s, size: 24)
    pdf.text text
    pdf.move_down 20
  end

  def create_line(pdf, text)
    pdf.font(Rails.root.join("app/assets/fonts/Lato-Medium.ttf").to_s, style: :normal, size: 12)
    pdf.text(text)
  end

  def create_check_list_item(pdf, text)
    pdf.move_down 5

    # Draw icon-check
    ref = File.join(Rails.root, "app/assets/images", "green-check.png")
    pdf.image(ref)

    # Draw list content
    y_position = pdf.cursor + 5
    pdf.draw_text(text, at: [40, y_position])
  end

  def create_feature(pdf, data)
    pdf.move_down 10

    ref = File.join(Rails.root, "app/assets/images", data[:avatar])
    pdf.image(ref)

    y_position = pdf.cursor + 34

    pdf.font(Rails.root.join("app/assets/fonts/Lato-Medium.ttf").to_s, style: :bold) do
      pdf.draw_text(data[:name], at: [60, y_position], size: 16)
    end

    pdf.font(Rails.root.join("app/assets/fonts/Lato-Regular.ttf").to_s) do
      pdf.fill_color "a9a9a9"
      pdf.draw_text(data[:title], at: [60, y_position - 24], width: 300, height: 12, size: 12)
      pdf.draw_text(data[:company_description], at: [60, y_position - 36], width: 300, height: 12, size: 12)
    end

    pdf.fill_color "000000"
    pdf.move_down 20

    pdf.font(Rails.root.join("app/assets/fonts/Martel-Regular.ttf").to_s) do
      pdf.text_box(data[:recommendation], at: [60, pdf.cursor], width: 450, size: 14)
    end

    pdf.move_down 100
  end

  def create_footer(pdf)
    # Copyright
    pdf.draw_text('©2023', at: [0, -24])

    # Draw Company Bookmark
    pdf.bounding_box([45, -9], :width => 10, :height => 16) do
      ref = File.join(Rails.root, "app/assets/images", "footer-icon.png")
      pdf.image(ref)
    end

    pdf.bounding_box([60, -17], :width => 40, :height => 100) do
      ref = File.join(Rails.root, "app/assets/images", "PeerSpot.png")
      pdf.image(ref)
    end

    # Page number
    pdf.draw_text('3', at: [520, -24])
  end
end
