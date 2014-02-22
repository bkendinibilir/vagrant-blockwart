class MyPlugin < Vagrant.plugin("2")
  name "vagrant-blockwart"

  provisioner "blockwart" do
  	require File.expand_path('../vagrant-blockwart/provisioner', __FILE__)
    Provisioner
  end
end