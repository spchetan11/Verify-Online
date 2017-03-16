ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span "Welcome to VerifyOnline"
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Verification Requests" do
          ol do
            VerificationRequest.where("payment_id IS NOT null").limit(5).map do |request|
              li link_to(request.verification_token.upcase, admin_verification_request_path(request))
              # li request.name.capitalize
            end
          end
        end
      end

    end

    columns do
      column do
        panel "Recent Colleges" do
          ol do
            College.all.limit(5).map do |college|
              li link_to(college.name.upcase, admin_college_path(college))
              # li request.name.capitalize
            end
          end
        end
      end

    end
  end # content
end
