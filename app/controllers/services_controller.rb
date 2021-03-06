class ServicesController < ApplicationController
  before_action :find_service, except: %i[index new create]

  def index
    @services = Service.includes(:price_records)
  end

  def show
    @current_price = format_price(@service.current_price)
    @price_records = @service.price_records.sort_by(&:effective_from)

    @service.visitor_count = @service.visitor_count + 1
    @service.save
  end

  def new
    authorized_for(current_user.id)
    @service = Service.new
    @current_price = @service.price_records.build
  end

  def edit
    authorized_for(current_user.id)
    @current_price = @service.current_price
  end

  def create
    authorized_for(current_user.id)
    @service = Service.new(service_params_create)
    @service.price_records.last.effective_from = DateTime.now

    if @service.save
      flash[:success] = 'Service successfully created'
      redirect_to @service
    else
      render 'new'
    end
  end

  def update
    authorized_for(current_user.id)
    unless @service.current_price == current_price_params[:monthly_price].to_i
      @service.price_records.build(current_price_params)
    end

    if @service.update(service_params_update)
      flash[:success] = 'Service was successfully updated'
      redirect_to @service
    else
      render 'edit'
    end
  end

  def destroy
    authorized_for(current_user.id)
    if @service.destroy
      flash[:success] = 'Service was successfully deleted'
      redirect_to @services_path
    else
      flash[:error] = 'Something went wrong'
      redirect_to @services_path
    end
  end

  private

  def find_service
    @service = Service.find(params[:id])
  end

  def service_params_create
    params.require(:service).permit(:name, :description, price_records_attributes: %i[monthly_price])
  end

  def service_params_update
    params.require(:service).permit(:name, :description)
  end

  def current_price_params
    extra = { effective_from: DateTime.now }
    pr_params = params.require(:service)
                      .except(:name, :description, :id)
                      .permit(price_records_attributes: %i[monthly_price])
    pr_params.values.first['0'].merge(extra)
  end
end
