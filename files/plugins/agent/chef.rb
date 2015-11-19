module MCollective
        module Agent
                class Chef<RPC::Agent

                        activate_when do
                                File.executable?("/usr/bin/chef-client")
                        end

                        def run(command)
                                if MCollective::Util.windows?
                                        begin
                                                ::Process.spawn(command, :new_pgroup => true)
                                                0
                                        rescue ::Process::Error => e
                                                1
                                        end
                                else
                                        child = fork {
                                                grandchild = fork {
                                                        exec command
                                                }
                                                if grandchild != nil
                                                        ::Process.detach(grandchild)
                                                end
                                        }
                                        return 1 if child.nil?
                                        ::Process.detach(child)
                                        return 0
                                end
                        end

                        action "run" do
                                if request[:debug]
                                        runcmd = "chef-client -l debug"
                                else
                                        runcmd = "chef-client"
                                end

                                exitcode = run(runcmd)
                        end

                end
        end
end
