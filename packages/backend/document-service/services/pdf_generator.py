from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
import io
import base64

class PDFGenerator:
    @staticmethod
    def generate_activity_report(activity_data: dict) -> str:
        """Genera PDF de reporte de actividad y devuelve base64"""
        buffer = io.BytesIO()
        doc = SimpleDocTemplate(buffer, pagesize=letter)
        styles = getSampleStyleSheet()
        story = []
        
        # Título
        story.append(Paragraph("Reporte de Actividad Académica", styles['Title']))
        story.append(Spacer(1, 12))
        
        # Datos
        fields = [
            ("Estudiante", activity_data.get("student", "N/A")),
            ("Actividad", activity_data.get("activity", "N/A")),
            ("Fecha", activity_data.get("date", "N/A")),
            ("Estado", activity_data.get("status", "N/A")),
            ("Descripción", activity_data.get("description", "N/A"))
        ]
        
        for label, value in fields:
            story.append(Paragraph(f"<b>{label}:</b> {value}", styles['Normal']))
            story.append(Spacer(1, 6))
        
        doc.build(story)
        pdf_bytes = buffer.getvalue()
        return base64.b64encode(pdf_bytes).decode('utf-8')