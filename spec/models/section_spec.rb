require 'rails_helper'

RSpec.describe Section, type: :model do
  describe 'validates' do
    [:title,
     :content_markdown,
     :icon,
     :index,
     :status].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end

    context 'with status' do
      it 'inactive' do
        section = create(:section, :inactive)
        expect(section.inactive?).to be true
        expect(section).to be_valid
      end

      it 'active' do
        section = create(:section)
        expect(section.active?).to be true
        expect(section).to be_valid
      end

      it 'other' do
        section = create(:section, :other)
        expect(section.other?).to be true
        expect(section).to be_valid
      end

      it 'other without alternative_text' do
        section = create(:section, :other)
        section.alternative_text = nil
        expect(section).not_to be_valid
      end
    end
  end

  describe '.content_markdown' do
    it 'parse markdown to html' do
      section = create(:section)
      html = <<-HTML.chomp.strip_heredoc
        <h1>Effugiam erit cinerem tenuere concurrere</h1>

        <h2>Mihi persequar et trementi muris constant tibique</h2>

        <p>Lorem markdownum, abstulerunt preces prima. Ripas et concipit <strong>genuit</strong>.</p>

      HTML

      expect(section.content).to eql(html)
    end
  end

  describe '.status_types' do
    subject(:section) { Section.new }

    it 'human enum' do
      hash = { I18n.t('enums.status_types.active') => 'active',
               I18n.t('enums.status_types.inactive') => 'inactive',
               I18n.t('enums.status_types.other') => 'other' }

      expect(Section.human_status_types).to include(hash)
    end
  end

  describe 'associations' do
    let(:section) { create(:section) }

    it { is_expected.to belong_to(:event) }
  end

  describe '.not_remove_default_section' do
    let(:event) { create(:event, :with_sections) }

    it 'remove any except default section' do
      event.sections.each do |section|
        section.destroy unless section.title.include? I18n.t('events.default_section')
      end
    end

    it 'throws exception when remove default section' do
      section = event.sections.find_by(title: I18n.t('events.default_section'))
      expect { section.destroy }.to raise_error RuntimeError, I18n.t('sections.error.be_deleted')
    end
  end
end
