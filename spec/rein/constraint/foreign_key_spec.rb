require 'spec_helper'

describe RC::ForeignKey, "#add_foreign_key_constraint" do
  let(:adapter) do
    Class.new do
      include RC::ForeignKey
    end.new
  end

  subject { adapter }

  before do
    stub(adapter).execute
    stub(adapter).add_index
  end

  context "with no options" do
    before { adapter.add_foreign_key_constraint(:books, :people) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id)") }
  end

  context "with a given referencing attribute" do
    before { adapter.add_foreign_key_constraint(:books, :people, :referencing => :author_id) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT author_id_fk FOREIGN KEY (author_id) REFERENCES people (id)") }
  end

  context "with a given name" do
    before { adapter.add_foreign_key_constraint(:books, :people, :name => :foo) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT foo FOREIGN KEY (person_id) REFERENCES people (id)") }
  end

  context "with a given on delete referential action" do
    before { adapter.add_foreign_key_constraint(:books, :people, :on_delete => :restrict) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE RESTRICT") }
  end

  context "with a given on update referential action" do
    before { adapter.add_foreign_key_constraint(:books, :people, :on_update => :restrict) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON UPDATE RESTRICT") }
  end

  context "with a given on delete and update referential action" do
    before { adapter.add_foreign_key_constraint(:books, :people, :on_delete => :cascade, :on_update => :cascade) }
    it { should have_received.execute("ALTER TABLE books ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE ON UPDATE CASCADE") }
  end

  describe "with a given index option" do
    before { adapter.add_foreign_key_constraint(:books, :people, :index => true) }
    it { should have_received.add_index(:books, :person_id) }
  end

  describe "with a referencing attribute and a index option" do
    before { adapter.add_foreign_key_constraint(:books, :people, :referencing => :author_id, :index => true) }
    it { should have_received.add_index(:books, :author_id) }
  end
end
