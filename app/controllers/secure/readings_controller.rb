class Secure::ReadingsController < Secure::ApplicationController
  def create
    p "create; params=#{params}"

    if is_invalid_float_param(:depth)
      return input_error(:depth)
    end

    if params[:salinity] != nil and is_invalid_float_param(:salinity)
      return input_error(:salinity)
    end

    if params[:salinity] != nil and is_invalid_string_param(:units_salinity)
      return input_error(:units_salinity)
    end

    if is_invalid_string_param(:units_depth)
      return input_error(:units_depth)
    end

    if params[:latitude] != nil or params[:longitude] != nil
      if is_invalid_float_param(:latitude)
        return input_error(:latitude)
      end

      if is_invalid_float_param(:longitude)
        return input_error(:longitude)
      end

      if not params[:latitude].to_f.between?(-90, 90)
        return input_error(:latitude)
      end

      if not params[:longitude].to_f.between?(-180, 180)
        return input_error(:longitude)
      end
    end

    full_params = reading_params
    full_params[:approved] = false
    full_params[:deleted] = false
    reading = Reading.create(full_params)

    p "create; result=success; reading_id=#{reading.id}"

    render :json => reading
  end

  def approve
    p "approve; params=#{params}"

    reading = Reading.find_by(id: params[:id])

    if reading == nil
      return not_found('record not found')
    end

    if reading.deleted == true
      return not_found('already deleted')
    end

    reading.update!(approved: true)

    p "approve; result=success; reading_id=#{reading.id};"

    render :json => reading
  end

  def delete
    p "delete; params=#{params}"

    reading = Reading.find_by(id: params[:id])

    if reading == nil
      return not_found('record not found')
    end

    reading.deleted = true
    reading.save!
    render :json => {status: 'Record deleted'}
  end

  private

  def reading_params
    params.permit(
        :depth,
        :units_depth,
        :salinity,
        :units_salinity,
        :description,
        :latitude,
        :longitude,
        :approved,
        :deleted
    )
  end
end
