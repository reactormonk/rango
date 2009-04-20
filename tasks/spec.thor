# coding: utf-8

class Spec < Thor
  desc "rango [path]", "Run Rango specs"
  def rango(path = "spec")
    command = %[spec #{path} --options spec/spec.opts]
    puts(command) ; exec(command)
  end

  desc "stubs", "Create stubs of all library files."
  def stubs
    Dir.glob("lib/**/*.rb").each do |file|
      specfile = file.sub(/^lib/, "spec").sub(/\.rb$/, '_spec.rb')
      unless File.exist?(specfile)
        %x[mkdir -p #{File.dirname(specfile)}]
        %x[touch #{specfile}]
        puts "Created #{specfile}"
      end
    end
    (Dir.glob("spec/rango/**/*.rb") + ["spec/rango_spec.rb"]).each do |file|
      libfile = file.sub(/spec/, "lib").sub(/_spec\.rb$/, '.rb')
      if !File.exist?(libfile) && File.zero?(file)
        %x[rm #{file}]
        puts "Removed empty file #{file}"
      elsif !File.exist?(libfile)
        puts "File exists just in spec, not in lib: #{file}"
      end
    end
  end
end