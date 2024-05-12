from sqlalchemy.orm import Session
from app.models.models import CallbackOrder, CallbackComputerBuild

class ServiceCenter:
    @staticmethod
    def create_callback_order(db: Session, order_data):
        new_order = CallbackOrder(name=order_data.name, phone_number=order_data.phone_number)
        db.add(new_order)
        db.commit()
        db.refresh(new_order)
        return new_order

    @staticmethod
    def create_callback_computer_build(db: Session, build_data):
        new_build = CallbackComputerBuild(
            name=build_data.name,
            phone_number=build_data.phone_number,
            budget=build_data.budget,
            usage_tasks=build_data.usage_tasks,
            build_preferences=build_data.build_preferences
        )
        db.add(new_build)
        db.commit()
        db.refresh(new_build)
        return new_build
